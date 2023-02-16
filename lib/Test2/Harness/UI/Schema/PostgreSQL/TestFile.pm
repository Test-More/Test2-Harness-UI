use utf8;
package Test2::Harness::UI::Schema::Result::TestFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::Serializer",
  "InflateColumn::Serializer::JSON",
  "Tree::AdjacencyList",
  "UUIDColumns",
);
__PACKAGE__->table("test_files");
__PACKAGE__->add_columns(
  "test_file_id",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "filename",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("test_file_id");
__PACKAGE__->add_unique_constraint("test_files_filename_key", ["filename"]);
__PACKAGE__->has_many(
  "coverages",
  "Test2::Harness::UI::Schema::Result::Coverage",
  { "foreign.test_file_id" => "self.test_file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "jobs",
  "Test2::Harness::UI::Schema::Result::Job",
  { "foreign.test_file_id" => "self.test_file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->has_many(
  "reportings",
  "Test2::Harness::UI::Schema::Result::Reporting",
  { "foreign.test_file_id" => "self.test_file_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2023-02-15 17:15:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rI0mpkkTcBCSEWJ94FIZlA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
