package Catalyst::Model::DBIC::Schema::PerRequest;

# ABSTRACT: Catalyst::Model::DBIC::Schema::PerRequest

use Moose;
extends 'Catalyst::Model';
with 'Catalyst::Component::InstancePerContext';

use Carp qw(croak confess);

use version; our $VERSION = version->new('v0.1.0');

=head1 DESCRIPTION

Allows you to get a clone of an existing L<Catalyst::Model::DBIC::Schema>
model with additional parameters passed to the L<DBIx::Class::Schema> clone.

 package MyApp::Model::RestrictedDB;

 use Moose;
 extends 'Catalyst::Model::DBIC::Schema::PerRequest';

 __PACKAGE__->config(target_model => 'DB');

 sub per_request_schema_attributes {
     my ($self, $c) = @_;
     return (restricting_object => $c->user->obj);
 }

=cut

=head1 ATTRIBUTES

=head2 target_model



=cut

has target_model => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

=head1 METHODS

=cut

sub build_per_context_instance {
    my ($self, $ctx) = @_;

    croak
        "This is a per-request only model, calling it on the app makes no sense"
        unless blessed($ctx);

    my $target = $ctx->model($self->target_model);

    my $new = bless({%$target}, ref($target));

    $new->schema($self->per_request_schema($new->schema, $ctx));

    return $new;
}

=head2 per_request_schema($c)

This method is called automatically and will clone your schema with attributes
coming from L<per_request_schema_attributes>. You can override this method
directly to return a schema you want, but it's probably better to override
C<per_request_schema_attributes>.

=cut

# Thanks to Matt Trout (mst) for this idea
sub per_request_schema {
    my ($self, $schema, $c) = @_;

    return $schema->clone($self->per_request_schema_attributes($c));
}

=head2 per_request_schema_attributes($c)

Override this method in your child class and return whatever parameters you
need for new schema instance.

 sub per_request_schema_attributes {
     my ($self, $c) = @_;
     return (restricting_object => $c->user->obj);
 }

=cut

sub per_request_schema_attributes {
    my ($self, $c) = @_;

    confess
        "Either per_request_schema_attributes needs to be created, or per_request_schema needs to be overridden!";
}

1;    ## eof
