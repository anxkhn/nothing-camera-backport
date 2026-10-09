# Licensing scope

The authorship inventory is part of this reconstruction kit. It does not assign a new license to Nothing Camera, Nothing firmware, Qualcomm or ArcSoft libraries, or the factory parcel model code regenerated from the user's APK.

`src/java/com/anx/camera/bridge/` and `src/smali/com/anx/camera/bridge/` contain the port's authored helpers. The Java is the readable implementation. The smali is the exact assembled representation used in r12. Scripts, tests and documentation are authored for this reconstruction kit. A repository-level license should explicitly scope any grant to this authored work.

`patches/r12.patch` contains modifications and limited surrounding context from decoded proprietary files. It is a delta, not an OEM source release. `provenance/r12-decoded.json` contains filenames and hashes only.

AndroidHiddenApiBypass 6.1 is Apache-2.0. Its unmodified compiled artifact downloads from Maven during reconstruction. The full upstream license and attribution are included here and copied into the APK under `assets/licenses/hiddenapibypass/`. The lock records the Maven artifact hash and upstream commit. No upstream AAR, JAR or DEX is stored in the published kit.

The original APK, factory APK, native libraries, firmware archives, extracted images, generated OEM model sources and private signing keys are local inputs or build outputs. They do not belong in the source publication.
