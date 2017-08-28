# Tween Module
Nevermore's premier Tween Module built for Roblox. Allows you to write interpolation code faster with a clear and simple API.
## Declaration
First let's load the module:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Nevermore = require(ReplicatedStorage:WaitForChild("Resources"))
local require = Nevermore.LoadLibrary

local Tween = require("Tween")
```
Once you've loaded the Tween Module, there are two ways to create a Tween. You can either interpolate a property of an object, or create a custom Tween with a function you want called each frame.

## Tween Properties

Tween function for tweening any property.  Like GuiObject:TweenPosition but the first two arguments are Object and Property

```lua
Tween(
	Object Object, -- or anything that holds the changing property
	String propertyName,
	Variant endValue,
	String easingDirection,
	String easingStyle,
	Number time,
	bool override = false,
	function(TweenStatus) callback = nil
)

Tween(workspace.Part, "CFrame", CFrame(10, 10, 10), "Out", "Quad", 2, true)

-- The nil in the following statement isn't read by the script
Tween(workspace.Part, "Transparency", 1, nil, "Linear", 2, true)
```
## Lightweight Custom Tween
Tweens created with `Tween.new` will call Callback every tween frame, with EasingFunction interpolating from 0 to 1 over the allotted duration.
```lua
Tween.new(number Duration, string EasingFunctionName, function Callback)

local newTween = Tween.new(.5, "OutQuad", function(x)
	print("This will be called with each 'Frame' of this tween")
end)
```
## Tween Objects
These are the functions and properties of the TweenObjects returned with each Tween creation.
```js
	Tween Object

		Methods:
			Tween:Resume()
//				Resumes a Tween that was Stop()ed
			Tween:Stop()
//				Stops a Tween
			Tween:Wait()
//				Yields until Tween finishes interpolating

		Properties:
			boolean Tween.Running
//				Whether the Tween is active
```

## Easing Functions
These are the available EasingFunctions:
You need to specify the directon of EasingFunctions that aren't "Directionless":

|   Directionless  |     In    |     Out    |     InOut    |     OutIn    |
|:----------------:|:---------:|:----------:|:------------:|:------------:|
|      Linear      |   InQuad  |   OutQuad  |   InOutQuad  |   OutInQuad  |
|      Spring      |  InCubic  |  OutCubic  |  InOutCubic  |  OutInCubic  |
|    SoftSpring    |  InQuart  |  OutQuart  |  InOutQuart  |  OutInQuart  |
|      RevBack     |  InQuint  |  OutQuint  |  InOutQuint  |  OutInQuint  |
| RidiculousWiggle |   InSine  |   OutSine  |   InOutSine  |   OutInSine  |
|      Smooth      |   InExpo  |   OutExpo  |   InOutExpo  |   OutInExpo  |
|     Smoother     |   InCirc  |   OutCirc  |   InOutCirc  |   OutInCirc  |
|                  | InElastic | OutElastic | InOutElastic | OutInElastic |
|                  |   InBack  |   OutBack  |   InOutBack  |   OutInBack  |
|                  |  InBounce |  OutBounce |  InOutBounce |  OutInBounce |

If you really need to, you can access the EasingFunctions for use with other modules through the following:
```lua
local Tween = require("Tween")
local Easing = Tween.EasingFunctions
```

# Bezier Module
Used to create Bezier functions.
## API
```lua
local EasingFunc = Bezier.new(0.17, 0.67, 0.83, 0.67)
```
Test and generate Bezier curves here at [cubic-bezier.com](http://cubic-bezier.com/) or at [greweb.me](http://greweb.me/bezier-easing-editor/example/)
Credit: Math borrowed from [here](https://gist.github.com/gre/1926947#file-keyspline-js)
