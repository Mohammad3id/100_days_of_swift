# iOS Highlights

These are features/facts/tips/tricks in iOS Dev that I came across during the 100 days and found interesting. They act as a "cheat sheet" for me to reference later. 

## Multiline String

```swift
var str = """hello"""
print(str)
```

Output:

```
Hello Hello
Hello Again
```

>Note: add a backslash at the end of a line to cancel its line break



## Custom String Interpolation

You can make custom string interpolations techniques for formatting values cleanly

```swift
let age = 22
var str = "Hi, I'm \(format: age, using: .spellOut)."
print(str)
```

Output:

```
Hi, I'm twenty-two.
```

Check out this [article](https://www.hackingwithswift.com/articles/178/super-powered-string-interpolation-in-swift-5-0) to learn more about it.



## Object-Like Tuples

Tuples in Swift are kinda like an on-the-fly object. Each member of the tuple can have a label and be accessed by that label much like how a property is accessed in an object.

```swift
let person = (name: "Jack", age: 23)
print(person.name)
```

Output:

```
Jack
```

---

Members can also be accessed using their numerical position.
```swift
let person = (name: "Jack", age: 23)
print(person.0)
```

Output:

```
Jack
```

---

Not all members need to be labeled though. Members without a label can still be accessed by their numerical position.

```swift
let person = ("Jack", age: 23)
print(person.0)
```

Output:

```
Jack
```



## Default Values for Dictionaries

```swift
let favoriteIceCream = [
    "Paul": "Chocolate",
    "Sophie": "Vanilla"
]

print(favoriteIceCream["Charlotte", default: "Unknown"])
```

Output:

```
Unknown
``` 



## Associated Values in Enums

Each enum member in Swift can have its own associated values. Here’s an example of how to use it:

```swift
enum Weather: Equatable {
    case sunny
    case windy(speed: Int)
    case rainy(chance: Int, amount: Int)
}

let weather = Weather.rainy(chance: 5, amount: 10)

if case .rainy(chance: 5, amount: let amount) = weather {
    "Rainy with chance of specifically five percent and amount of \(amount)"
}
```

Output: 

```
Rainy with chance of specifically five percent and amount of 10
```



## Doubles lose precision with higher numbers

This has to do with the way doubles are represented in memory. Swift will even warn us if we tried to store a big value

```swift
let value: Double = 90000000000000001  // Warning: '90000000000000001' is not exactly representable as 'Double'; it becomes '90000000000000000'
```



## isMultiple(of:) Method

A cleaner way to check if a number is divisible by some other number

```swift
let number = 84
number.isMultiple(of: 7)    //same as: number % 7 == 0
```

Output: 

```
true
```



## Comparable Enums

Enums can conform Comparable protocol to be able to used in comparisons. Results are based on the order of appearance of enum members.

```swift
enum Sizes: Comparable {
    case small
    case medium
    case large
}

let first = Sizes.small
let second = Sizes.large

print(first < second)
```

Output: 

```
true
```



## Switch case “fallthrough”
 
When running a case in a switch case statement, you can use “fallthrough” keyword to run the following case regardless of its condition.

```swift
for number in 0...5 {
    print("(number = \(number))")

    switch number {
    case 0:
        print("Case 0")
    case 1:
        print("Case 1")
        fallthrough
    case 2:
        print("Case 2")
        fallthrough
    case 3:
        print("Case 3")
    case 4:
        print("Case 4")
    default:
        print("Default Case")
    }
    
    print()
}
```

Output:

```
(number = 0)
Case 0

(number = 1)
Case 1
Case 2
Case 3

(number = 2)
Case 2
Case 3

(number = 3)
Case 3

(number = 4)
Case 4

(number = 5)
Default Case
```



## Range as a switch case value

You can use a range as a case value in a switch case statement.

```swift
let score = 84

switch score {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did OK.")
default:
    print("You did great!")
}
```

Output: 

```
You did OK.
```


## Range with arrays

You can retrieve multiple elements (sub-array) from an array using ranges.

```swift
let names = ["Piper", "Alex", "Suzanne", "Gloria", "Taylor"]
print(names[1...3])
print(names[1...])    // Elements from index 1 to the end of the array
```

Output: 

```
["Alex", "Suzanne", "Gloria"]
["Alex", "Suzanne", "Gloria", "Taylor"]
```



## Loops can be labeled

In situations where we need to break an outer loop from an inner loop, we can label the outer loop we wanna break and use that label with the break statement.

```swift
outerLoop: 
for i in 1...4 {
    for j in 1...4 {
        let product = i * j
        print ("\(i) * \(j) is \(product)")

        if product == 6 {
            print("Done!")
            break outerLoop
        }
    }
}
```

Output:

```
1 * 1 is 1
1 * 2 is 2
1 * 3 is 3
1 * 4 is 4
2 * 1 is 2
2 * 2 is 4
2 * 3 is 6
Done!
```



## Functions with a single expression return it automatically 

If a function contains a single expression, it returns that expression automatically. This behaviour is used heavily in SwiftUI. The following two functions behave the same:

```swift
func doMath() -> Int {
    return 5 + 5
}

func doMoreMath() -> Int {
    5 + 5
}
```



## An if-else can be used as an expression

```swift
let food = "Apple"

let response = if food == "Apple" {
    "I love apples!"
} else {
    "No thanks"
}

print(response)
```

Output: 

```
I love apples!
```

This feature works well with functions when returning a single expression

```swift
func giveDog(food: String) -> String {
    if food == "treat" {
        "The dog ate it"
    } else {
        "The dog didn't like it"
    }
}

giveDog(food: "treat")
```

Output: 

```
The dog ate it
```



Function Parameter Label

Function parameters can be labeled. Labels are used when calling the function (externally) while the parameter name is used in function implementation (internally). This allows for a more natural sounding pronunciation of function calls and implementation statements which improves readability. 
func sayHello(to name: String) {          // parameter "name" has the label "to"
    print("Hello, \(name)!")              // "name" is used internally
}
sayHello(to: "Tylor")                     // "to" is used externally
Output: Hello, Tylor!

You can omit parameter labels using underscores.
func greet(_ person: String) {
    print("Hello, \(person)!")
}
greet("Taylor")
Output: Hello, Tylor!



Variadic Functions

Variadic functions take any arbitrary number of arguments of the same type. Internally, these parameters are grouped in an array.
func sum(_ numbers: Int..., power: Int = 1) -> Int {
    var sumResult = 0
    
    for number in numbers {
        sumResult += number
    }
    
    var powerResult = 1
    for _ in 1...power {
        powerResult *= sumResult
    }
    
    return powerResult
}

sum(5, 2, 1)                // 5 + 2 + 1
sum(5, 2, 1, power: 3)      // (5 + 2 + 1) ^ 3
Output:
8
512



Function “throws”

A function marked with “throws” indicate that the possibility of it throwing an error which should be handled by its caller. Such functions needs to be called using “try” to acknowledge the possibility of an error.
enum MyError: Error {
    case someError
}

func doSomethingWith(_ text: String) throws -> Bool {
    if (text == "Swift") {
        return true
    }
    throw MyError.someError
}


do {
    try doSomethingWith("JavaScript")
} catch { error
    print("Something went wrong")
}
Output: Something went wrong



Function “rethrows”

A function marked with “rethrows” indicates that it accepts a closure among its parameters that is marked with “throws” and is called in the function. This is better than just marking the function with normal “throws” as if a non-throwing closure is passed, we know no errors can be thrown, and hence we won’t need to use “try” when calling the function with non-throwing closures. Arrays “map” method is a good example of this.
let numbers = [1, 2, 3, 4]

numbers.map { number in           // no need for try, closure can't throw an error 
    number * 2
}

try numbers.map { number in       // have to use try, closure may throw an error
    if (number == 0) {
        number * 2
    } else {
        throw MyError.someError
    }
}

Check our this article for more info about error handling in functions and “throws” and “rethrows” keywords:
Using try catch in Swift – Donny Wals



Why surrounding a throwing function calls with a do-catch block isn’t enforced 

Functions should be able to propagate errors to its caller if that’s the needed behaviour. Enforcing a do-catch whenever calling a throwing function won’t allow us to handle the errors anywhere we want.



Function “inout” parameter

We can allow a function to change the value of an argument that is being passed to it. Kinda like passing a value by reference. Here’s an example of a function that doubles a number in place.
func doubleInPlace(_ number: inout Int) {
    number *= 2
}

var number = 1
doubleInPlace(&number)
print(number)
Output: 2
Note: the passed value must be variable, not a constant. Also it should be marked with an & symbol to make sure we’re aware of the possibility of its change.



Closures can’t be called with parameter labels
 
We can only call closures with positional arguments.
let play = { (game: String) in
    print("I'm playing \(game)")
}

play("soccer")          // Output: I'm playing soccer
play(game: "soccer")    // Error



Closure Shorthand Parameters

When writing a closure, we can omit the parameters list and use their out-of-the-box shorthand names. Consider the following function.
func run(_ closure: (Int, Int, Int) -> Int) {
    print(closure(5, 10, 15))
}

Normally, we would call the function and pass it a closure with desired names for its 3 parameters.
run { (firstNumber, secondNumber, thirdNumber) in
    firstNumber + secondNumber + thirdNumber
}
Output: 30

But we can be more precise and use shorthand parameters. They are the default names for parameters and we don’t need to specify any parameter names when using them.
run { 
    $0 + $1 + $2
}
Output: 30



Operators can be used as closures

Operators under the hood are actually functions. Hence, they can be passed to other functions as closures. Consider the next example where we calculate the factorial of 5.
let factorial = (1...5).reduce(1) { (accumulator, newValue) in
    result * newValue
}

print(factorial)
Output: 120

Here we used the reduce method to multiply a sequence of numbers from 1 to 5. We used a closure that accepts two integers and multiply the “accumulator” and the “newValue” together, starting with an accumulator of 1. Notice that the closure signature is the same as the multiply operation (*), which means we can use it directly as a closure to achieve the same result.
let factorial = (1...5).reduce(1, *)

print(factorial)
Output: 120



Closures Captured Variables

When creating a closure inside a function, local variables used inside the closure are captured and kept alive with the closure until it’s destroyed, even if the original function exits and gets released. This behavior is essential to make sure the closure can be executed without problems. Consider the following function.

func makeIncrementingPrinter(_ start: Int) -> () -> Void {
    var value = start
    return {
        print(value)
        value += 1
    }
}

let printIncrement = makeIncrementingPrinter(3)

printIncrement()
printIncrement()
printIncrement()
printIncrement()
Output:
3
4
5
6

You can save the captured variable’s original value that the closure was created with using a “capture list”
func makeIncrementingPrinter(_ start: Int) -> () -> Void {
    var value = start
    return { [originalValue = value] in
        print("\(value), Original: \(originalValue)")
        value += 1
    }
}

let printIncrement = makeIncrementingPrinter(3)

printIncrement()
printIncrement()
printIncrement()
printIncrement()
Output:
3, Original: 3
4, Original: 3
5, Original: 3
6, Original: 3

Check this article to know more about closure capturing.
Closures Capture Semantics: Catch them all! – Crunchy Development



Structs Observers

You can run some code as a reaction to setting a property value. Use willSet to run code before setting the property value, or didSet to run code after setting the value.
struct Person {
    var name: String {
        willSet {
            print("I will change my name from \(name) to \(newValue)")
        }
        didSet {
            print("I changed my name from \(oldValue) to \(name)")
        }
    }
}

var person = Person(name: "Spongebob")
person.name = "Patrick"
person.name = "Squidward"
Output:
I will change my name from Spongebob to Patrick
I changed my name from Spongebob to Patrick
I will change my name from Patrick to Squidward
I changed my name from Patrick to Squidward



Mutating Methods

Struct instances assigned to constants (using “let”) are immutable. Normal methods defined in structs can’t mutate properties unless they are marked with “mutating” keyword. These methods can only be called on instances that are assigned to variables. Calling mutating methods on a constant (immutable) instance will not compile.
struct Counter {
    var value = 0
    
    func printValue() {
        print("Current value: \(value)")
    }
    
    mutating func increment() {
        print("incremented!")
        value += 1
    }
}

var counter = Counter(value: 5)
counter.increment()
counter.printValue()                       // Current value: 6

let constantCounter = Counter(value: 5)
constantCounter.increment()                // Error
constantCounter.printValue()

Note: non-mutating methods can’t call mutating functions (for obvious reasons).



Handling Emojis in Strings

Emojis are often broken down into multiple special characters to account for all their variations which is better than treating each single combination as a separate character with a unique encoding. Swift abstracts this detail when dealing with strings though, so they still act as a single character to us.
var strWithEmoji = "123🙎🏻‍♂️"
print(strWithEmoji.count)
Output: 4

Since characters don’t necessarily take the same size of bytes in memory, we can’t use indexing syntax with strings to get a certain character.
var strWithEmoji = "123🙎🏻‍♂️56"
print(strWithEmoji[4])         // Error

Also for that same reason, it’s faster to use str.isEmpty rather than str.count == 0 

Check these articles for more info about emojis and strings in Swift.
Why are strings structs in Swift? - a free Understanding Swift tutorial
Why using isEmpty is faster than checking count == 0 – Hacking with Swift
