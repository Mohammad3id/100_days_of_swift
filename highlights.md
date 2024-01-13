# iOS Highlights

These are features/facts/tips/tricks in iOS Dev that I came across during the 100 days and found interesting. They act as a "cheat sheet" for me to reference later.

# \# Day 1

## Multiline String

> There is a bug in Swift multiline string literals syntax highlighting on github so don't wory if the string is highlighted with a red color, it's valid Swift code.

```swift
var str = """
Hello \
Hello
Hello Again!
"""
print(str)
```

Output:

```
Hello Hello
Hello Again
```

> Note: add a backslash at the end of a line to cancel its line break

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

# \# Day 2

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

\
Members can also be accessed using their numerical position.

```swift
let person = (name: "Jack", age: 23)
print(person.0)
```

Output:

```
Jack
```

\
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

let fav = favoriteIceCream["Charlotte", default: "Unknown"]
print(fav)
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
    "Rainy with a chance of specifically five percent and amount of \(amount)"
}
```

Output:

```
Rainy with a chance of specifically five percent and amount of 10
```

# \# Day 3

## Doubles lose precision with higher numbers

This has to do with the way doubles are represented in memory. Swift will even warn us if we tried to store a big value

```swift
let value: Double = 90000000000000001  // Warning: '90000000000000001' is not exactly representable as 'Double'; it becomes '90000000000000000'
```

## `isMultiple(of:)` Method

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

## Switch case `fallthrough`

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

## Range as a `switch` case value

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

# \# Day 4

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

# \# Day 5

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

## An `if-else` block can be used as an expression

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

## Function Parameter Label

Function parameters can be labeled. Labels are used when calling the function (externally) while the parameter name is used in function implementation (internally). This allows for a more natural sounding pronunciation of function calls and implementation statements which improves readability.

```swift
func sayHello(to name: String) {     // parameter "name" has the label "to"
    print("Hello, \(name)!")         // "name" is used internally
}
sayHello(to: "Tylor")                // "to" is used externally
```

Output:

```
Hello, Tylor!
```

You can omit parameter labels using underscores.

```swift
func greet(_ person: String) {
    print("Hello, \(person)!")
}
greet("Taylor")
```

Output:

```
Hello, Tylor!
```

## Variadic Functions

Variadic functions take any arbitrary number of arguments of the same type. Internally, these parameters are grouped in an array.

```swift
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

sum(5, 2, 1)            // 5 + 2 + 1
sum(5, 2, 1, power: 3)  // (5 + 2 + 1) ^ 3
```

Output:

```swift
8
512
```

## Function `throws`

A function marked with “throws” indicate that the possibility of it throwing an error which should be handled by its caller. Such functions needs to be called using “try” to acknowledge the possibility of an error.

```swift
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
```

Output:

```
Something went wrong
```

## Function `rethrows`

A function marked with “rethrows” indicates that it accepts a closure among its parameters that is marked with “throws” and is called in the function. This is better than just marking the function with normal “throws” as if a non-throwing closure is passed, we know no errors can be thrown, and hence we won’t need to use “try” when calling the function with non-throwing closures. Arrays “map” method is a good example of this.

```swift
let numbers = [1, 2, 3, 4]

numbers.map { number in        // no need for try, closure can't throw an error
    number * 2
}

try numbers.map { number in    // have to use try, closure may throw an error
    if (number == 0) {
        number * 2
    } else {
        throw MyError.someError
    }
}
```

Check our this [article](https://www.donnywals.com/working-with-throwing-functions-in-swift/) for more info about error handling in functions and “throws” and “rethrows” keywords.

## Why surrounding a throwing function calls with a `do-catch` block isn’t enforced

Functions should be able to propagate errors to its caller if that’s the needed behaviour. Enforcing a do-catch whenever calling a throwing function won’t allow us to handle the errors anywhere we want.

## Function “inout” parameter

We can allow a function to change the value of an argument that is being passed to it. Kinda like passing a value by reference. Here’s an example of a function that doubles a number in place.

```swift
func doubleInPlace(_ number: inout Int) {
    number *= 2
}

var number = 1
doubleInPlace(&number)
print(number)
```

Output:

```
2
```

> Note: the passed `inout` argument must be variable, not a constant. Also it should be marked with an `&` symbol to make sure we’re aware of the possibility of its change.

# \# Day 6

## Closures can’t be called with parameter labels

We can only call closures with positional arguments.

```swift
let play = { (game: String) in
    print("I'm playing \(game)")
}

play("soccer")          // Output: I'm playing soccer
play(game: "soccer")    // Error
```

# \# Day 7

## Closure Shorthand Parameters

When writing a closure, we can omit the parameters list and use their out-of-the-box shorthand names. Consider the following function.

```swift
func run(_ closure: (Int, Int, Int) -> Int) {
    print(closure(5, 10, 15))
}
```

\
Normally, we would call the function and pass it a closure with desired names for its 3 parameters.

```swift
run { (firstNumber, secondNumber, thirdNumber) in
    firstNumber + secondNumber + thirdNumber
}
```

Output:

```
30
```

\
But we can be more precise and use shorthand parameters. They are the default names for parameters and we don’t need to specify any parameter names when using them.

```swift
run {
    $0 + $1 + $2
}
```

Output:

```
30
```

## Operators can be used as closures

Operators under the hood are actually functions. Hence, they can be passed to other functions as closures. Consider the next example where we calculate the factorial of 5.

```swift
let factorial = (1...5).reduce(1) { (accumulator, newValue) in
    result *= newValue
}

print(factorial)
```

Output:

```
120
```

Here we used the reduce method to multiply a sequence of numbers from 1 to 5. We used a closure that accepts two integers and multiply the “accumulator” and the “newValue” together, starting with an accumulator of 1. Notice that the closure's signature is the same as that of the multiply operation `*`, which means we can use it directly as a closure to achieve the same result.

```swift
let factorial = (1...5).reduce(1, *)

print(factorial)
```

Output:

```
120
```

## Closures Captured Variables

When creating a closure inside a function, local variables used inside the closure are captured and kept alive with the closure until it’s destroyed, even if the original function exits and gets released. This behavior is essential to make sure the closure can be executed without problems. Consider the following function.

```swift
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
```

Output:

```
3
4
5
6
```

\
You can save the captured variable’s original value that the closure was created with using a “capture list”

```swift
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
```

Output:

```
3, Original: 3
4, Original: 3
5, Original: 3
6, Original: 3
```

\
Check this [article](https://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/) to know more about closure capturing.

# \# Day 8

## Structs Observers

You can run some code as a reaction to setting a property value. Use willSet to run code before setting the property value, or didSet to run code after setting the value.

```swift
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
```

Output:

```
I will change my name from Spongebob to Patrick
I changed my name from Spongebob to Patrick
I will change my name from Patrick to Squidward
I changed my name from Patrick to Squidward
```

## Mutating Methods

Struct instances assigned to constants (using “let”) are immutable. Normal methods defined in structs can’t mutate properties unless they are marked with “mutating” keyword. These methods can only be called on instances that are assigned to variables. Calling mutating methods on a constant (immutable) instance will not compile.

```swift

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
counter.printValue() // Current value: 6

let constantCounter = Counter(value: 5)
constantCounter.increment() // Error
constantCounter.printValue()
```

> Note: non-mutating methods can’t call mutating functions (for obvious reasons).

## Handling Emojis in Strings

Emojis are often broken down into multiple special characters to account for all their variations which is better than treating each single combination as a separate character with a unique encoding. Swift abstracts this detail when dealing with strings though, so they still act as a single character to us.

```swift
var strWithEmoji = "123🙎🏻‍♂️"
print(strWithEmoji.count)
```

Output:

```
4
```

\
Since characters don’t necessarily take the same size of bytes in memory, we can’t use indexing syntax with strings to get a certain character.

```swift
var strWithEmoji = "123🙎🏻‍♂️56"
let fourthChar = strWithEmoji[4]     // Error
```

Also for that same reason, it’s faster to use `str.isEmpty` rather than `str.count == 0`

\
Check these two articles for more info about emojis and strings in Swift:

- [Why are strings structs in Swift?](https://www.hackingwithswift.com/quick-start/understanding-swift/why-are-strings-structs-in-swift)
- [Why using isEmpty is faster than checking count == 0](https://www.hackingwithswift.com/articles/181/why-using-isempty-is-faster-than-checking-count-0)

# \# Day 9

## Structs with both custom and default initializers

Structs have a default memberwise initializer. If we were to define our own custom initializer, the default memberwise one would be removed.

```swift
struct Person {
    var name: String
    init() {
        self.name = "anonymous"
    }
}

let person1 = Person()                  // No issues
let person2 = Person(name: "Taylor")    // Error
```

We can keep both by defining our custom initializer as an extension

```swift
struct Person {
    var name: String
}

extension Person {
    init() {
        self.name = "anonymous"
    }
}

let person1 = Person()                  // No issues
let person2 = Person(name: "Taylor")    // Also no issues :)
```

## `lazy` Properties

Structs can have properties created only when they're accessed for the first time. This can be helpful if a property is not always needed and is expensive to create.

```swift
struct ExpensiveStruct {
    init() {
        // some expensive work here
        print("ExpensiveStruct instance created!")
    }
}


struct MyStruct {
    lazy var expensiveInstance = ExpensiveStruct()
    init() {
        print("MyStruct instance created!")
    }
}


var myInstance = MyStruct()
myInstance.expensiveInstance
```

Output:

```
MyStruct instance created!
ExpensiveStruct instance created!
```

> Note: We can only use lazy properties on variable struct instances as they have to modify the instance to initialize the property.

## Accessing `self` with `lazy` properties initialization

`lazy` properties are initialized only when needed, which means they are initialized after their containing struct instance is initailaized, which means we can access `self` in there initialization closure. This can be helpful if a property depends on the values of other properties.

```swift
struct MyStruct {
    let value: Int

    lazy var lazyValue = {
        let newValue = self.value + 1
        print("Property (lazyValue) created!")
        return newValue
    }()

    init(_ value: Int) {
        self.value = value
        print("MyStruct instance created!")
    }
}


var myInstance = MyStruct(5)
print(myInstance.lazyValue)
```

> Note: initialization closure should have the calling parentheses `()` at the end of it. Otherwise, the property would be initialized with the closue itself rather than its return value.

## `static` methods & properties with structs vs enums

Static methods and properties are available without creating needing an instance. They're useful for grouping related and frequently used values and functionalities without polluting the namespace.

We can use a struct to group static members as well as enums. Difference being that enums without any cases can't have instances and hence would totally prevent us from creating an pointless instance.

```swift
enum Randomizer {
    private static var entropy = Int.random(in: 1...1000)

    static func nextInt() -> Int {
        entropy += 1
        return entropy
    }
}

Randomizer.nextInt()  // Generates a random number
Randomizer.nextInt()  // Increments it by 1 with every call
```

We can achieve the same functionality with structs too by making an empty private initializer. I prefer this approach to using an `enum` as I think it's better to leave enums for "enumeration" purposes.

```swift
struct Randomizer {
    private static var entropy = Int.random(in: 1...1000)

    static func nextInt() -> Int {
        entropy += 1
        return entropy
    }

    private init() {}
}

Randomizer.nextInt()  // Generates a random number
Randomizer.nextInt()  // Increments it by 1 with every call
Randomizer()          // Error: 'Randomizer' initializer is inaccessible due to 'private' protection level
```

## Structs with `private` members don't have default memberwise initializers

It's probably better to be explicit about which members to expose in the initializer's parameter list and which to keep private when using there's private properties. Swift designers seem to agree.

```swift
struct MyStruct {
    var member1: Int
    var member2: Int
    private var member3 = 0
}


let instance = MyStruct()    // Error: 'MyStruct' initializer is inaccessible due to 'private' protection level
```

# \# Day 10

## Structs vs Classes

- A Class can inherit from other classes. Structs can't inherit from other structs.
- Classes don't have a default memberwise initializer. This is because memberwise initializers would cause [problems](https://www.hackingwithswift.com/quick-start/understanding-swift/why-dont-swift-classes-have-a-memberwise-initializer) when used with inheritence.
- Struct instances are passed by value, while class instances are passed by reference.
- Classes have deinitializers, structs don't.
- Variable properties in constant classe instances can be modified. This also means that class methods that change properties don't need to be marked as `mutating`.

## `final` Classes

Classes can be marked as `final` which means they can't be inherited from. Something to keep in mind.

## Struct instances can be observed for changes

We can add observers on the whole instance of a struct to observe any state changes.

```swift
struct Point {
    var x: Int
    var y: Int
}

var point = Point(x: 1, y: 2) {
    willSet {
        print(newValue.x, newValue.y)
    }
}

point.x = 2
```

Output:

```
2 2
```


Check this [article](https://chris.eidhof.nl/post/structs-and-mutation-in-swift/) about structs and mutation in Swift. It discusses some interesting ideas.

## API Design Guidlines

Swift's documentation has a list of conventions & best practices for designing our APIs. Check it out [here](https://www.swift.org/documentation/api-design-guidelines/).

## Automatic Reference Counting (ARC)

Swift tracks how many identifiers are referencing a class instance with a reference count. When that count goes to zero, the deinitializer code is executed and the instance is destroyed. 

>This behavior doesn't exist with struct instances cause it's not really needed since they act like normal values and are passed by value. Class instances however, they can be referenced by multiple identifiers since they're passed by reference, and hence it's hard to pinpoint when they will be destroyed, which makes deinitializers very helpful.

# \# Day 11

## Composing protocols from other protocols

Protocols can be composed from other protocols which makes things a lot more reusable.

```swift
protocol Payable {
    func calculateWages() -> Int
}

protocol NeedsTraining {
    func study()
}

protocol HasVacation {
    func takeVacation(days: Int)
}

protocol JuniorEmployee: Payable, NeedsTraining { }
protocol SeniorEmployee: Payable, HasVacation { }
```

## Protocol extensions for default method implementations

We can make an extension to protocols and provide a default implementation of protocol methods in their.

```swift
protocol Identifiable {
    var id: String {get set}
    func identify()
}

extension Identifiable {
    func identify() {
        print("My ID is \(id).")
    }
}

struct User: Identifiable {
    var id: String
}

let myUser = User(id: "12345")
myUser.identify()
```

Output:

```
My ID is 12345.
```

## Group protocol-conforming struct method implementations in an extension

In a struct that conforms to some protocol, we can implement the protocol methods in an extension of that struct.

```swift
protocol Identifiable {
    var id: String {get set}
    func identify()
}

struct User {
    var id: String
    var name: String
}

extension User: Identifiable {
    func identify() {
        print("My name is \(name) ID is \(id)")
    }
}

let myUser = User(id: "12345", name: "Taylor")
myUser.identify()
```

Output:

```
My name is Taylor ID is 12345
```

> Note: Extensions can't have stored properties. They can only have computed properties and method implementations.

Check out this [article](https://www.swiftbysundell.com/articles/conditional-conformances-in-swift/) to learn about "Conditional Conformance".
