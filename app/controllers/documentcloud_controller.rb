# app/controllers/documentcloud_controller.rb:
# Show information about one particular request.
#
# Copyright (c) 10Layer Software Development. All rights reserved.
# Email: jason@10layer.com; WWW: http://10layer.com/

class DocumentcloudController < ApplicationController

	def sync_all
		@attachments = []
		IncomingMessage.find_each { |im|
	        im.get_attachments_for_display.each { |attachment|
			next if attachment.documentcloud_sync?
			print "Processing incoming message id " + attachment.incoming_message_id.to_s + "\n"
	                incoming_message = IncomingMessage.find(attachment.incoming_message_id)
	                info_request = InfoRequest.find(incoming_message.info_request_id)
	                url_title = info_request.url_title
			FileUtils.cp(attachment.filepath, "/tmp/" + attachment.display_filename.to_s)
	                result_json = RestClient.post("https://jason%4010layer.com:u4XXEjcFbPhq@sourceafrica.net/api/upload.json",
	                       :file   => File.new("/tmp/" + attachment.display_filename.to_s, "rb"),
	                       :title  => attachment.display_filename,
	                       :source => "Ask Africa",
	                       :access => "private",
			       :published_url => incoming_message_url(incoming_message),
	                       :data   => {"date" => incoming_message.updated_at, "subject" => incoming_message.subject, "mail_from" => incoming_message.mail_from, 
					"mail_from_domain" => incoming_message.mail_from_domain }
	               )
			result = JSON.parse(result_json)
			@attachments << { :url => incoming_message_url(incoming_message), :filename => attachment.display_filename.to_s, :dcurl => result["canonical_url"], :result => result }
			FoiAttachment.update(attachment.id,
				:documentcloud_sync => true,
				:documentcloud_id => result["id"],
				:documentcloud_url => result["canonical_url"]
			)
			FileUtils.rm("/tmp/" + attachment.display_filename.to_s)
	        }
	}
    end
end
