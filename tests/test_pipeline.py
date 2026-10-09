import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import reconstruct
import verify_apk


class PipelineTests(unittest.TestCase):
    def test_hash_rejects_wrong_input(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "input"
            path.write_bytes(b"changed OEM input")
            with self.assertRaisesRegex(ValueError, "SHA-256 mismatch"):
                reconstruct.require_hash(path, "0" * 64)

    def test_tree_rejects_missing_changed_and_extra_files(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "smali").mkdir()
            path = root / "smali/Example.smali"
            path.write_text(".class LExample;\n")
            expected = reconstruct.tree_records(root)
            (root / "original").mkdir()
            (root / "original/AndroidManifest.xml").write_text("ignored raw original")
            with patch.object(reconstruct, "read_json", return_value=expected):
                reconstruct.verify_tree(root)
                path.write_text("changed")
                with self.assertRaises(ValueError):
                    reconstruct.verify_tree(root)
                path.unlink()
                with self.assertRaises(ValueError):
                    reconstruct.verify_tree(root)
                path.write_text(".class LExample;\n")
                (root / "smali/Extra.smali").write_text("extra")
                with self.assertRaises(ValueError):
                    reconstruct.verify_tree(root)

    def test_patch_is_complete_and_hash_locked(self):
        records = reconstruct.read_json("patch-files.json")
        text = (reconstruct.ROOT / "patches/r12.patch").read_text()
        self.assertEqual(len(records), 70)
        for name, record in records.items():
            self.assertIn("+++ b/" + name + "\n", text)
            self.assertEqual(len(record["after"]), 64)
        self.assertEqual(len(reconstruct.read_json("native-libraries.json")), 11)

    def test_cli_help(self):
        for name in (
            "reconstruct",
            "extract",
            "local_inputs",
            "verify_apk",
            "export_patch",
            "record_firmware",
        ):
            subprocess.run(
                [
                    sys.executable,
                    str(reconstruct.ROOT / "scripts" / (name + ".py")),
                    "--help",
                ],
                check=True,
                stdout=subprocess.DEVNULL,
            )

    def test_apk_rejects_compressed_native_and_altered_assets(self):
        with tempfile.TemporaryDirectory() as directory:
            original = Path(directory) / "original.apk"
            rebuilt = Path(directory) / "rebuilt.apk"
            with zipfile.ZipFile(original, "w") as archive:
                archive.writestr("assets/model", b"unchanged")
            with patch.object(verify_apk, "require_hash"):
                with zipfile.ZipFile(rebuilt, "w") as archive:
                    archive.writestr("assets/model", b"changed")
                with self.assertRaisesRegex(
                    ValueError, "assets/native libraries changed"
                ):
                    verify_apk.verify(original, rebuilt)
                with zipfile.ZipFile(rebuilt, "w") as archive:
                    archive.writestr("assets/model", b"unchanged")
                    archive.writestr(
                        "lib/arm64-v8a/example.so",
                        b"ELF",
                        compress_type=zipfile.ZIP_DEFLATED,
                    )
                with self.assertRaisesRegex(ValueError, "Native library compressed"):
                    verify_apk.verify(original, rebuilt)


if __name__ == "__main__":
    unittest.main()
