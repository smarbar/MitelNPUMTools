Deploy Module {
  By PSGalleryModule {
      FromSource Build\MitelNPUMTools
      To PSGallery
      WithOptions @{
        ApiKey = $ENV:GALLERY_API_KEY
      }
  }
}