.class public final Lcom/anx/camera/bridge/PublicImageWriter;
.super Ljava/lang/Object;
.source "PublicImageWriter.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static create(Landroid/view/Surface;IIII)Landroid/media/ImageWriter;
    .locals 1

    .line 9
    new-instance v0, Landroid/media/ImageWriter$Builder;

    invoke-direct {v0, p0}, Landroid/media/ImageWriter$Builder;-><init>(Landroid/view/Surface;)V

    .line 10
    invoke-virtual {v0, p1}, Landroid/media/ImageWriter$Builder;->setMaxImages(I)Landroid/media/ImageWriter$Builder;

    move-result-object p0

    .line 11
    invoke-virtual {p0, p2}, Landroid/media/ImageWriter$Builder;->setImageFormat(I)Landroid/media/ImageWriter$Builder;

    move-result-object p0

    .line 12
    invoke-virtual {p0, p3, p4}, Landroid/media/ImageWriter$Builder;->setWidthAndHeight(II)Landroid/media/ImageWriter$Builder;

    move-result-object p0

    .line 13
    const-wide/16 p1, 0x30

    invoke-virtual {p0, p1, p2}, Landroid/media/ImageWriter$Builder;->setUsage(J)Landroid/media/ImageWriter$Builder;

    move-result-object p0

    .line 14
    invoke-virtual {p0}, Landroid/media/ImageWriter$Builder;->build()Landroid/media/ImageWriter;

    move-result-object p0

    .line 9
    return-object p0
.end method
