#!/usr/bin/env perl

use lib::abs './lib';

use warnings;
use strict;

use Test::More;
use Catalyst::Test 'TestApp';


is(TestApp->model('DB')->schema->test_attr, 'DB', 'ok');
is get('/'), 'DBPerRequest';

done_testing;