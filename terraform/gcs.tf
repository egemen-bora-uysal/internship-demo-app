#Create a Google Cloud Storage bucket
resource "google_storage_bucket" "demo_app_bucket" {
  name          = var.demo_name
  project       = var.project_id
  location      = var.region
  storage_class = "REGIONAL"
}

#Upload object to given Google Cloud Storage bucket
resource "google_storage_bucket_object" "picture" {
  name   = "Bojack Horseman"
  source = "${path.module}/bucket-object/bojack.jpeg"
  bucket = google_storage_bucket.demo_app_bucket.name
}
