using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;

namespace wssTechParts2._0
{
    internal static class SafeImages
    {
        public static void Save(HttpPostedFile file, string path)
        {
            if (file == null || file.ContentLength <= 0 || file.ContentLength > 5 * 1024 * 1024)
                throw new ArgumentException("La imagen debe ocupar entre 1 byte y 5 MB.");
            string extension = Path.GetExtension(path).ToLowerInvariant();
            ImageFormat format;
            switch (extension)
            {
                case ".jpg": case ".jpeg": format = ImageFormat.Jpeg; break;
                case ".png": format = ImageFormat.Png; break;
                case ".gif": format = ImageFormat.Gif; break;
                default: throw new ArgumentException("Usa una imagen JPG, PNG o GIF.");
            }
            using (var image = Image.FromStream(file.InputStream, false, true))
            {
                if (image.Width > 6000 || image.Height > 6000 || (long)image.Width * image.Height > 20000000)
                    throw new ArgumentException("Las dimensiones de la imagen son demasiado grandes.");
                // Decode and re-encode; never store uploaded executable bytes verbatim.
                using (var clean = new Bitmap(image)) clean.Save(path, format);
            }
        }
    }
}
