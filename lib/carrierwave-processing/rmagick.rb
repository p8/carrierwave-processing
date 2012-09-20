module CarrierWave
  module Processing
    module RMagick
      # Strips out all embedded information from the image
      def strip
        manipulate! do |img|
          img.strip!
          img = yield(img) if block_given?
          img
        end
      end

      # Reduces the quality of the image to the percentage given
      def quality(percentage)
        manipulate! do |img|
          # Quality not available for Rmagick4j,
          # or I don't know how to make it work
          unless defined?(Java::Rmagick4j)
            img.write(current_path){ self.quality = percentage }
          end
          img = yield(img) if block_given?
          img
        end
      end

      # Auto Orients images
      # may not work if using stip, since orientation is in the EXIF data
      def rotate
        manipulate! do |img|
          img = img.auto_orient
          img = yield(img) if block_given?
          img
        end
      end

      # Adds a watermark at the bottom center
      def watermark(source_watermark)
        manipulate! do |img|
          logo = Magick::Image.read(source_watermark).first
          img = img.composite(logo, Magick::SouthGravity, Magick::OverCompositeOp)
          img = yield(img) if block_given?
          img
        end
      end
    end
  end
end
