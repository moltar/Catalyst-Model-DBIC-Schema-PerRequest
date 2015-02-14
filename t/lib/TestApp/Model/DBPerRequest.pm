package TestApp::Model::DBPerRequest;

use Moose;
extends 'Catalyst::Model::DBIC::Schema::PerRequest';

__PACKAGE__->config(target_model => 'DB');

sub per_request_schema_attributes {
    my ($self, $c) = @_;

    return (test_attr => 'DBPerRequest');
}