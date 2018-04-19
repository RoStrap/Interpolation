# Tween Module
RoStrap's premier Tween Module built for Roblox. Allows you to write interpolation code faster with a clear and simple API.
## Declaration
First let's load the module:
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Resources = require(ReplicatedStorage:WaitForChild("Resources"))

local Tween = Resources:LoadLibrary("Tween")
local Enumeration = Resources:LoadLibrary("Enumeration")
```
Once you've loaded the Tween Module, there are two ways to create a Tween. You can either interpolate a property of an object, or create a custom Tween with a function you want called each frame.

## Tween Properties
Tween function for tweening any property.  Like GuiObject:TweenPosition but the first two arguments are Object and Property

```lua
Tween(
	Object Object, -- or anything that holds the changing property
	String propertyName,
	Variant endValue,
	Number (from Enumeration) easingFunction,
	Number time,
	bool override = false,
	function(TweenStatus) callback = nil
)

local OutQuad = Enumeration.EasingFunction.OutQuad.Value
local Standard = Enumeration.EasingFunction.Standard.Value

Tween(workspace.Part, "CFrame", CFrame.new(10, 10, 10), OutQuad, 2, true)
Tween(workspace.Part, "Transparency", 1, Standard, 2, true)
```
## Lightweight Custom Tween
Tweens created with `Tween.new` will call Callback every tween frame, with EasingFunction interpolating from 0 to 1 over the allotted duration.

```lua
Tween.new(number Duration, string EasingFunctionName, function Callback)

local Deceleration = Enumeration.EasingFunction.Deceleration.Value

local newTween = Tween.new(0.5, Deceleration, function(x)
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
			Tween:Restart()
//				Makes the Tween go back to timeElapsed = 0

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
|   Acceleration   | InElastic | OutElastic | InOutElastic | OutInElastic |
|   Deceleration   |   InBack  |   OutBack  |   InOutBack  |   OutInBack  |
|       Sharp      |  InBounce |  OutBounce |  InOutBounce |  OutInBounce |
|     Standard     |

If you want to, you can access the EasingFunctions for use with other modules through either of the following:

```lua
local Easing = Resources:LoadLibrary("Easing")

-- If you want an array of all Easing Enumerations
local EnumerationItems = Enumeration.EasingFunction:GetEnumerationItems()
for i = 1, #EnumerationItems do
	print(EnumerationItems[i])
end
```

# Bezier Module
Used to create Bezier functions.
## API
```lua
local EasingFunc = Bezier.new(0.17, 0.67, 0.83, 0.67)
```
Test and generate Bezier curves here at [cubic-bezier.com](http://cubic-bezier.com/) or at [greweb.me](http://greweb.me/bezier-easing-editor/example/)
Credit: Math borrowed from [here](https://github.com/gre/bezier-easing)
