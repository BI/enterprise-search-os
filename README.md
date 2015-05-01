# Enterprise Search (Open Source)

Enterprise Search is an application that offers an advanced UI to the Lucene query language, through `elasticsearch`.

## Usage

In order to use this application, you have to add your own indices and configure a few files accordingly.

The current implementation contains the stubs for 3 sample indices: `an_index`, `another_index` (data indices) and `website` (web-content index). They are not functional indices (i.e. you should change them with your own), but they provide a basic structure to easily edit the files related to them.

## `app/assets`, `app/controllers`

You should not need to edit any content in this dir.

## `app/elastics`

It contains the files used by the `elastics` gem. You should edit the content of the `an_index` and `another_index` dirs, and the content of the `count_cache.rb` file as per your customization. The other files in that dir should not need any editing. (see the `elastics` gem documentation for details)

## `app/helpers`

You should not need to edit any content in this dir.

## `app/models`

You should edit the content of the `an_index` and `another_index` dirs as per your customization. The classes in these dirs may be used to index a DB (see the rake tasks), however the application doesn't need any DB in order to work, since it only uses the elasticsearch indices through the `elastics` gem.

## `app/views`

You should edit the content of the `content_searches` and the `searches/an_index` and `searches/another_index` dirs according to your needs. the `layouts` dir should contain one layout per index.

## `config`

You should edit the `initializers/elastics.rb` an `elastics.yml` configuration files (see the `elastics` gem documentation for details).
You should also edit the `settings.yml` file, which contains the application settings that control the UI and other functionalities, and eventually the `databases.yml` file (used if you need to index a DB).

## `lib`

You should edit the `tasks/indexer.rake` file, and eventually the `crawler.rb` file (which provides a crawler to index the content of an online website).
