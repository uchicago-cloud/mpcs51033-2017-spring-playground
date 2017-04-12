
--threadsafe_override=false --max_service_instances=1


curl -X GET http://localhost:8080/


curl -X GET http://localhost:8080/user/default/json/


curl -X POST -H "Content-Type: multipart/form-data" -F caption='curl' -F "image=@kitten.jpg"  http://localhost:8080/post/lolakitty/

API
===

# Get a json list of most recent submitted pictures
http://--.appspot.com/user/<USERNAME>/json/?id_token=XXXX


# See a list of the most recent on a web page (useful for debugging
http://--.appspot.com/user/<USERNAME>/web/?id_token=XXXX


# Endpoint for posting images to server. There is an optional "caption" parameter that you can use.
http://--.appspot.com/post/<USERNAME>/?id_token=XXXX

# Add ability to delete a photo
http://--.appspot.com/image/<key>/delete/?id_token=XXX

Uploading
=========
gcloud app deploy app.yaml --project uchicago-cloud-photo-timeline

Locat Development
=================
dev_appserver.py app.yaml
