module CarrierWave
  module Processing
    module MiniMagick
      # Strips out all embedded information from the image
      def strip
        minimagick! do |img|
          img.strip
          img = yield(img) if block_given?
          img
        end
      end

      # Reduces the quality of the image to the percentage given
      def quality(percentage)
        minimagick! do |img|
          img.quality(percentage.to_s)
          img = yield(img) if block_given?
          img
        end
      end

      # Auto Orients images
      # may not work if using stip, since orientation is in the EXIF data
      def rotate
        minimagick! do |img|
          img.auto_orient
          img = yield(img) if block_given?
          img
        end
      end

      # Adds a watermark at the center
      def watermark(source_watermark)
        minimagick! do |img|
          if defined?(ImageProcessing)
            watermark = ::MiniMagick::Image.new(source_watermark)
          else
            watermark = ::MiniMagick::Image.open(source_watermark)
          end
          watermark.resize img[:dimensions].join('x')
          img = img.composite(watermark, 'png') do |c|
            c.gravity "center"
          end
          img
        end
      end

      unless defined?(ImageProcessing)
        def minimagick!(&block)
          manipulate!(&block)
        end
      end

    end
  end
end
