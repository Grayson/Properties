# FCSPropertyHack

Look, let's face it, Apple's implementation of [key-value observing][kvo] is, well... Okay, it's a great technology.  I love it.  [Cocoa Bindings][cb] makes updating the UI easy and normal KVO makes it easy to respond to data changes.  It's brilliant!

Unfortunately, the syntax is awful.  Seriously.  It's bad.  It's not like other languages have it figured out (that I've seen).  I haven't yet seen anything that I really wanted in a KVO-ish system.

Then, I saw [PromiseKit][pk] and it introduced me to a concept that I hadn't considered before.  Basically, by returning a block from a getter method, we can hack together a slightly unfamiliar but powerful syntax.  That's when I saw an opportunity for a horribly awful hack that makes responding to property changes more palatable for me.

## A new syntax for responding to property changes

Let's make a few assumptions.  First, I hate listening to properties based on string keys.  I get that it's feasible to implement, but we don't get anything out of it.  There's no compiler support if we change a property (but not the key path).  Second, I hate that we essentially have one entrance point for *every* value change that an object observes.  I couldn't figure out a good way to resolve the prior without resorting to some exceptional macros, but I could feasibly solve the latter.

Imagine if we could use Blocks in order to handle KVO:

	foo.property(@"bar").onDidChange(^(FCSPropertyChangingInformation i) { NSLog(@"%@", i.newValue); });

But wait!  There's this whole timing issue involved.  What about responding to changes *before* they happen?

	foo.property(@"bar").onWillChange(^(id _) { ... });

You can attach multiple observation blocks (note that due to an implementation detail, the order of execution cannot be assumed or guaranteed):

	foo.property(@"bar").onDidChange(^(id _) { NSLog(@"One block"); });
	foo.property(@"bar").onDidChange(^(id _) { NSLog(@"Two block"); });

Finally, this syntax also gives you a way to readily remove observation of a particular block:

	id observationIdentifier = foo.property(@"bar").onDidChange(^(id _) { NSLog(@"Remove me."); });
	...
	foo.property(@"bar").remove(observationIdentifier);

## Problems

This is a hack.  There's a lot to be said about the hack, but it's still overriding expected behavior.  The part that gives me the most cause for concern is the fact that I'm swizzling out `-dealloc`.  Yep, `-dealloc`.  I do that because associated objects are released *after* the object they're associated with is deallocated.  That causes a problem with cleanup.  Sure, there's also the problem that this tosses associated objects around everywhere, but swizzling `-dealloc` should give everyone a pause for concern.

I suppose that raises the question of whether this is usable.  I suppose so.  Sure, why not?  I personally may not use this for any project that requires a high degree of sophistication that guarantees complete safety, but I may toss it at some pet projects and home projects.  Just be aware that if you use this, you're throwing in a hack that overrides `-dealloc` just for some convenient syntax.

## Future

At the moment, this is more or less a proof of concept.  I'm just tossing this out there because I was interested in the problem space and wanted to mess around with abusing Block syntax.  Here are a few things I might be interested in doing moving forward:

1. Stop swizzling `-dealloc`.  I don't have a plan for this yet, but I'd feel much better not swizzling it.
2. Document.  Seriously, I just tossed this together as a quick hack in a few evenings.  If I actually use it, I may add some documentation.
3. Add some extra project targets.  Integrating this should be as easy as integrating a framework/library.  Testing might be nice.
4. Allow for non-ARC compilation.  I've never had a project that crossed these lines without just tossing around `-fno-objc-arc`, so that'd be an interesting step.

## Usage

Why wait so late to describe how to use this?  Because you probably shouldn't.  But who am I to judge?

	git clone git@github.com:Grayson/Properties.git
	cd Properties
	git submodule update --init

I think that may do it.  I haven't actually tested, but it should get you relatively close.  I'm using [JRSwizzle][jrs] to handle swizzling `-dealloc`.  That has you check out a particular release tag ("v1.0").  You may need to check that tag out explicitly.

When you add these files to your project, you'll need to add `-fno-objc-arc` to NSObject+FCSPropertySyntax.m in your project's "Compiled Sources".  That's absolutely necessary since, well, this code swizzles `-dealloc` which ARC identifies as a major no-no (actually, just referencing `-dealloc`, but it's still a bad idea).  Everything else assumes ARC (at the moment), so, um, you should be using ARC.

With those added, you'll need to add `NSObject+FCSPropertySyntax.h` to the `#import` section of every .m file in which you intend to use this.  Alternatively, you can add it to your .pch and get it everywhere, but that may be overkill.

## Some additional thoughts on potential usage

So, you may notice that each block receives a custom object (`FCSPropertyChangingInformation`).  That's an absurdly long name.  I decided that it would be better to encapsulate all of the information that is actually being received into one object to simplify the block syntax.  Passing in a half dozen or so parameters to a block is an absurd pain.  Apple decided to hide some of those details in an NSDictionary, but I don't think that dictionaries are a good abstraction in this case (seriously, there's a finite amount of information that we actually care about).  The FCSPropertyChangingInformation object should provide all of the information that you actually care about.

The FCSPropertyChangingInformation object exposes a property called `@newObject` (I use the "@" symbol for properties, can we make that a thing?) but the getter is called `-theNewValue`.  This absolves the compiler requirement concerning method names starting with "new".  I'd like a better name so I could avoid this hack, but I'm assuming we're all sufficiently modern to use the dot-notation syntax for properties and it won't be a problem.  If you or your company still uses method calling syntax only, send me an email and I'll chew out whoever writes your coding guidelines.

## An additional thought on property syntax

I nearly always side on the notion that the Objective-C 2.0 dot-notation syntax should **only** be used for properties that would otherwise represent simple accessors (readonly implementations implemented as methods are fine so long as they don't do work that is expensive or could cause side effects).  This hack is a place where I make an exception.  I'm not happy that I'm abusing the dot-notation syntax, but I find it much more pleasant than the alternative standard syntax.  I'm willing to sublimate my otherwise strongly-held and hard-fought opinion when it benefits me in this way.

## License

Does this really need a license?  It's a hack.  Look, use as you please.  If you make it better, at least submit a pull request or make your changes available publicly.  That's just kindness.  I'm going to assume this code is [Public Domain][pd] and will assume any pull requests are [Public Domain][pd] as well.

## Contact

For questions, complaints, or just otherwise wanting to rant about Objective-C:

Grayson Hansard  
[info@fromconcentratesoftware.com](mailto:info@fromconcentratesoftware.com)  
[@Grayson](http://twitter.com/Grayson) (Twitter)  
[Github/Grayson](http://github.com/Grayson)


[kvo]: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html#//apple_ref/doc/uid/10000177i
[cb]: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CocoaBindings/CocoaBindings.html#//apple_ref/doc/uid/10000167i
[pk]: https://github.com/mxcl/PromiseKit
[jrs]: https://github.com/rentzsch/jrswizzle
[pd]: http://en.wikipedia.org/wiki/Public_domain