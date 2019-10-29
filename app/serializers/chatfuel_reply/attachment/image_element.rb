module ChatfuelReply
  module Attachment
    ImageElement = Struct.new(:title, :image_url, :subtitle, :buttons) do
      def to_h
        {
          title: title,
          image_url: image_url,
          subtitle: subtitle,
          buttons: buttons.map(&:to_h)
        }
      end
    end
  end
end