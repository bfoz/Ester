Ester
=====

Ester is a desktop-class [Selective Laser Sintering]() 3D Printer. It's designed to be built by anyone with a modest workshop, and should be able to sinter a variety of materials. For now we're focusing on commonly available polyester powders, with an eye towards moving to nylon in the near future.

Procedural Engineering
----------------------

Ester isn't designed in the traditional manner and you won't find any of the standard CAD file formats in this repository. If you're used to the big CAD packages, you may be in for a shock. If you're coming from the [OpenSCAD](http://www.openscad.org) world, then you'll feel right at home.

Ester's design is written entirely in the [Ruby language](https://www.ruby-lang.org/en/) using a custom [Domain Specific Language](http://en.wikipedia.org/wiki/Domain-specific_language). Instead of drawing out each part of the design, we're writing a program that knows how to design the system we want. Well, that's the idea anyway. The tools need more work, but we're getting there.

Installing the Prerequisites
============================

To develop for Ester you'll need to have a few things installed first. These instructions will get you started.

Ruby
----

All of Ester's designs are written in Ruby, so that's where you'll start. Use the official [Ruby installation instructions](https://www.ruby-lang.org/en/installation/) to install the latest Ruby for your system.

If you're on a Mac, and have Mavericks or Yosemite, then you're in luck because Ruby 2.0 is already installed. You're welcome to use rvm, rbenv, etc to get a more recent ruby if you like, but it's not required.

Bundler
-------

[Bundler](http://bundler.io) is a tool that helps manage Ruby projects and is often already installed. If you don't already have it, pop open a command prompt and type

    gem install bundler

To see if you already have bundler, you can type the following, and see if bundler is listed. If not, you'll need to use the previous command to install it.

    gem list bundler

Gems
----

Ester depends on a number of other Ruby gems that in turn depend on a bunch of other stuff. It's all very interesting, if you like that sort of thing. Otherwise, just use your favorite command prompt to run this command:

    bundle install

You can probably get a cup of coffee at this point. If all is proceeding according to plan, Bundler is taking care of an awful lot of stuff so that you don't have to.

Trimble SketchUp
----------------

Currently the only available 3D output format is a variant of Ruby that can be read by Trimble's free [SketchUp](http://www.sketchup.com) package (the Pro version works too). Go [here](http://www.sketchup.com) and click on the big red button that says "Download SketchUp". Fill out the form and click the big "Download SketchUp Make" button. Install the package after it finishes downloading and you should be good to go.

Clones
======

As with all git-hosted projects, you'll need to clone the repository before you can do much of anything. If you're using the command line, switch to your favorite development directory and:

    git clone git://github.com/bfoz/Ester.git

Of course, if you're using GitHub (you're already here, right?), then you should [fork](https://github.com/bfoz/Ester/fork) first, and then clone.

Seeing the Ester
================

By now I'm sure you're tired of installing things and are itching to get started. Now's your chance.

First, we'll need to generate the output files. Go back to your trusty command line window, make sure you're in the newly-cloned project directory, and run:

    rake sketchup

You'll need to run that command whenever you make changes to Ester's files, so keep it handy.

That last command should have created a file named 'ester.su' in the 'build' subdirectory. Now that you have that file, you can...

1. Fire up SketchUp and make sure you're looking at an empty window (there might be someone's grandfather staring back at you).
2. Go to the Window menu and select "Ruby Console". You should now see another, smaller, window.
3. In the little text box at the bottom of the new window, type


    load "/path-to-the-cloned-repository/build/ester.su"

If all of that worked, your previously empty window should be displaying a very tiny version of Ester. Click the Zoom Extents button on the toolbar (or select Zoom Extents from the Camera menu) to get the bigger picture.

That's it! You're all set to join us. Welcome to the sintering revolution.

If you have any problems, feel free to [ask for help](bfosdick@gmail.com).

License
=======

Copyright 2014 by [Brandon Fosdick](bfoz@bfoz.net) and released under the [BSD license](http://opensource.org/licenses/BSD-2-Clause).

