class FileDownloaderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "file_downloader_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
