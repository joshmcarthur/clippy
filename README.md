# Clippy

Clippy is a web application built using Ruby on Rails which allows video or
audio files to be uploaded, transcribed and summarised (using OpenAI, however
local processing and Cloudflare AI are planned as well). Processing somewhat
assumes uploads are meeting recordings, however this is not a strict limitation
and any spoken audio (or video with spoken audio) is processable.

## Getting started

1. `bin/setup`
2. Provide an OpenAI API key using one of the supported methods
3. Run `bundle exec good_job` in a terminal tab to process background jobs
4. Visit `http://localhost:3000` in your browser, upload a video or audio file
   to get started.

## Prerequisites

#### Ruby

Ruby is required for this application to run. Check the Ruby version constraint
in the [Gemfile](Gemfile). At the time of writing, the Ruby version installed
was Ruby 3.0.0p0, however the code for this application is agnostic and should
run on any recent or upcoming version of Ruby. All Ruby library dependencies
will be run by running `bundle install` (which is done for you by the setup
script)

#### FFmpeg

[FFmpeg](https://ffmpeg.org/) is required to extract audio from video files, and
to generate thumbnails from video files. It is easiest installed using your
operating system's package manager. The codecs required depend on the video and
audio formats to be processed, but a typically FFmpeg installation will handle
all common video and audio formats.

#### OpenAI Key

An [OpenAI API key](https://platform.openai.com/account/api-keys) is required to
process transcribe and summarise uploaded media. The OpenAI key can be
configured in the application by setting `Rails.application.config.openai_key`.
This configuration key defaults to `Rails.application.credentials.openai.key`,
then `ENV["CLIPPY_OPENAI_KEY"]`. This means that you can use [Rails' encrypted
credentials](https://edgeguides.rubyonrails.org/security.html#custom-credentials)
to store your OpenAI key within the repository encrypted, or inject or otherwise
provide the API key using an environment variable.

#### PostgreSQL

At this stage, the application requires a recent version of PostgreSQL for:

1. Range support
2. JSON storage and querying support
3. Full-text search support
4. GoodJob queueing (e.g. LISTEN/NOTIFY among other PG-specific features used by GoodJob)

It's planned to replace all this with SQLite alternatives, so as to allow the
application to be run self-contained, without dependencies on external systems.

## Processing steps

The processing pipeline is comparatively simple:

1. Audio is extracted from the video (or copied as-is if an audio file is
   provided)
2. Audio is split into 10 minute chunks (Whisper has a 25mb limit on upload
   size)
3. Each chunk is submitted for transcription
4. The transcription results are assembled back into a cohesive block of text.
5. Each 'segment' identified by Whisper (a 'segment' is often, but not always, a
   sentence-level fragment of text) is saved, along with it's transcribed text
   and timestamps.
6. The transcription text is used to summarise the upload, generating a short
   description of the transcript and extracting entities from the text (entities
   can be different 'types' - people, organisations, etc), and are useful for
   matching across uploads.

It's important to note that because processing utilises AI services, the results
of processing the same upload multiple times can generate slightly different
results when summarising and extracting entities, though the transcription
generally remains largely the same.

## AI Processing Cost

As of writing, transcribing and summarising one hour meetings had a cost of just
under USD$0.30, with a significant portion of this being transcription. Both
[local](https://github.com/openai/whisper) and [Cloudflare
AI](https://developers.cloudflare.com/workers-ai/models/whisper/) support is
fairly trivial to add since these alternatives are broadly compatible with the
simple API calls made already.

It is important to note that this application is _unauthenticated_ and does not
rate limit or otherwise restrict uploads (or any web traffic). _It is expected
that a proxy such as Nginx is placed in front of the Rails application if
required to restrict and control access in a deployed environment._

## Running the tests

The tests in this application can be run using `rails test test:system`. This
will run unit, integration and system tests. _It's important to note that there
are currently no tests for this application_, but this is how they can and will
be run.

Because of the use of general-purpose Stimulus controllers in this application,
there are also aspirations to test these controllers with Jest tests, at which
point they are likely to be (re)open sourced in their own repository.

## Deployment

This application is designed to be easy to ship as a Docker image, and run as a
container. The repository includes a [Dockerfile](Dockerfile) which includes
everything required to run the application. The only required pieces of
configuration are a `DATABASE_URL`, `SECRET_KEY_BASE` (which can be generated
with `rails secret`), and either `RAILS_MASTER_KEY` to decrypt encrypted
credentials for OpenAI, or `OPENAI_API_KEY`.

Storage for uploaded files is local by default, though a range of other
providers aren easily supported, including AWS S3 (and S3-compatible providers
like Cloudflare R2, Backblaze, etc), Google Cloud Storage, and Azure Storage
Service.

If using the default disk-based service, and you are running the application in
a container, you should provide a Docker volume mounted to the '/rails/storage/'
directory that is writeable by the container. If you do not do this, uploaded
files will be lost when the container is replaced.

_Note that this application does not include any authentication or access
control._ It's expected that this application be run behind a proxying web
server such as Nginx, Caddy, or similar which can authenticate and manage
traffic. Alternatively, Cloudflare offers tunneling and access control products
which can be used to control access to an instance of this application run on a
local network.

## The name 'Clippy'

I just needed something to pass to `rails new`, and I don't doubt this name is
used all over the internet. It's not intended to be particularly unique or
original, but does serve to identify the application in things like page titles.

## Built with

- [Ruby on Rails](https://rubyonrails.org/) - Web framework
- [Bootstrap 5](https://getbootstrap.com/) - UI and utility class framework
- [PostgreSQL](https://postgresql.org/) - Database engine
- [GoodJob](https://github.com/bensheldon/good_job) - Background job batching
  and processing
- [Hotwite](https://hotwired.dev/), particularly
  [Turbo](https://turbo.hotwired.dev/) and
  [Stimulus](https://stimulus.hotwired.dev/)
- Plenty of others, see the [Gemfile](Gemfile) for a list of dependencies.

## Contributing

Contributions are welcome, but not really expected. If you really want to
contribute something, please understand that:

- This is essentially a learning project that I've built for fun and to explore
  the experience of starting a new Rails application with the default
  configuration - particularly propshaft and importmap.
- I will generally create a PR for significant changes, especially if/when I
  have tests, but will otherwise treat myself to committing pretty much anything
  to `main`.
- I might decide to just stop working on this at any time, this includes
  handling contributions. This is a personal development project.
- I might decide to throw out this code and rewrite parts as serverless
  functions or something just to see if I can do it.
- I've built a functional UI, but haven't been to exceptional effort. I've
  entirely stuck to standard Bootstrap components, so just tweaking the CSS
  variables will give you a completely different look.
- I'll do my best to help out, but if you're wanting to run your own instance or
  change something to work differently, it's likely you'll need to be able to do
  this on your own.
- Please don't consider this project maintained or production ready (though I
  don't think I've done anything egregiously bad practise or insecure that would
  prevent this).

## License

This project is licensed under the GNU General Public License v3.0 - see
[LICENSE.md](LICENSE.md) for details.
