# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_16_101236) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audio_segments", force: :cascade do |t|
    t.integer "sequence_number"
    t.decimal "duration"
    t.float "start_time"
    t.float "end_time"
    t.bigint "upload_id", null: false
    t.json "raw", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "text"
    t.text "formatted"
    t.index ["upload_id", "sequence_number"], name: "index_audio_segments_on_upload_id_and_sequence_number", unique: true
    t.index ["upload_id"], name: "index_audio_segments_on_upload_id"
  end

  create_table "clips", force: :cascade do |t|
    t.bigint "transcript_id", null: false
    t.float "start_time"
    t.float "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transcript_id"], name: "index_clips_on_transcript_id"
  end

  create_table "segments", force: :cascade do |t|
    t.bigint "transcript_id", null: false
    t.float "start_time"
    t.float "end_time"
    t.text "text"
    t.json "raw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transcript_id"], name: "index_segments_on_transcript_id"
  end

  create_table "summaries", force: :cascade do |t|
    t.bigint "transcript_id", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.json "entities", default: {}
    t.index ["transcript_id"], name: "index_summaries_on_transcript_id"
  end

  create_table "transcripts", force: :cascade do |t|
    t.bigint "upload_id", null: false
    t.string "language", limit: 5
    t.text "text"
    t.json "raw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["upload_id"], name: "index_transcripts_on_upload_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language", limit: 5, null: false
    t.datetime "processing_started_at"
    t.datetime "processing_ended_at"
    t.string "processing_stage", default: "pending", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audio_segments", "uploads"
  add_foreign_key "clips", "transcripts"
  add_foreign_key "segments", "transcripts"
  add_foreign_key "summaries", "transcripts"
  add_foreign_key "transcripts", "uploads"
end
