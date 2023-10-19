class_name PredictionComponent
extends HTTPRequest

@export var recording := "user://recording.wav"
@export var endpoint := ""


var _url = "http://192.168.0.12:4000/api/"


func send_audio():
	var file = FileAccess.open(recording, FileAccess.READ)
	var content = file.get_buffer(file.get_length())
	file.close()
	
	var headers = [	"Content-Type: multipart/form-data; boundary=\"boundary\""]
	var body = PackedByteArray()

	body.append_array("--boundary\r\n".to_utf8_buffer())
	body.append_array("Content-Disposition: form-data; name=\"recording\"; filename=\"recording.wav\"\r\n".to_utf8_buffer())
	body.append_array("Content-Type: audio/wav\r\n\r\n".to_utf8_buffer())
	body.append_array(content)
	body.append_array("\r\n--boundary--\r\n".to_utf8_buffer())
	
	self.request_raw(_url + endpoint, headers, HTTPClient.METHOD_POST, body)
