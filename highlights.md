# iOS Highlights

These are features/facts/tips/tricks in iOS Dev that I came across during the 100 days and found interesting. They act as a "cheat sheet" for me to reference later.

> Disclaimer: Some of these code snippets are my own and some others are copied from HackingWithSwift.com articles. All deserved credibility & appreciation goes to the author for his incredible work.

## Multiline String

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

Enums can conform Comparable protocol to be able to be used in comparisons. Results are based on the order of appearance of enum members.

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
        fallthrough
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
Default Case

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

## Calling throwing function

Functions marked as `throws` can call the throwing functions without `try` and without any further handling to let the error propagate to its caller. Non-throwing functions on the other hand, should do one of the following:

- Use a `do-catch` block to handle the error
- Use `try?` when calling throwing functions which makes them return `nil` in case of errors
- Use `try!` to ignore the possibility of an error being thrown, but that's usually not recommended.

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

## Closures can’t be called with parameter labels

We can only call closures with positional arguments.

```swift
let play = { (game: String) in
    print("I'm playing \(game)")
}

play("soccer")          // Output: I'm playing soccer
play(game: "soccer")    // Error
```

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
But we can be more concise and use shorthand parameters. They are the default names for parameters and we don’t need to specify any parameter names when using them.

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
    accumulator * newValue
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

`lazy` properties are initialized only when needed, which means they are initialized after their containing struct instance is initailaized, which means we can access `self` in their initialization closure. This can be helpful if a property depends on the values of other properties.

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

Static methods and properties are available without creating an instance. They're useful for grouping related and frequently used values and functionalities without polluting the namespace.

We can use a struct to group static members as well as enums. Difference being that enums without any cases can't have instances and hence would totally prevent us from creating a pointless instance.

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

> This behavior doesn't exist with struct instances cause it's not really needed since they act like normal values and are passed by value. Class instances however, they can be referenced by multiple identifiers since they're passed by reference, and hence it's hard to pinpoint when they will be destroyed, which makes deinitializers very helpful.

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

We can make an extension to protocols and provide a default implementation of protocol methods in there.

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

## Make a struct conform to a protocol with an extension

We can make a struct conform to a protocol with an extension. That way, we can group protocol method implementations in a separate place from the main struct itself.

```swift
protocol Identifiable {
    var id: String { get set }
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

> Note: Extensions can't have stored properties. They can only have computed properties and method implementations. That's why the `id` property is defined in the struct body and not in the extension.

Check out this [article](https://www.swiftbysundell.com/articles/conditional-conformances-in-swift/) to learn about "Conditional Conformance".

## Optionals unwrapping with `if let` syntax

Swift null safety prevent us from accessing optional (possible `nil`) values directly to prevent errors. We need to unwrap optional values first, and one of the ways it's done by is `if let` syntax. Consider the following variable of type 'optional string':

```swift
var optionalStr: String? = nil
```

We can unwrap it to safely use the string if it exits, or do something else if it doesn't, using `if let` syntax:

```swift
if let unwrappedStr = optionalStr {
    print("String length: \(unwrappedStr.count)")
} else {
    print("String is nil and can't be accessed")
}
```

Or even more concisely:

```swift
if let optionalStr {
    print("String length: \(optionalStr.count)")
} else {
    print("String is nil and can't be accessed")
}
```

Output:

```
String is nil and can't be accessed
```

## Optinals unwrapping with `guard let` syntax

This syntax is very useful when we're checking if some value is `nil` at the beginning of some scope (e.g, function, loop, etc.) before continuing the execution. It "guards" the rest of the scope from `nil` values as if it finds an optional value to be `nil` it requires us to exit the scope (with `return`, `throw`, `continue`, etc).

```swift
func greet(_ name: String?) {
    guard let name else {
        print("You didn't provide a name")
        return
    }

    print("Hello, \(name)!")
}

greet(nil)
greet("Taylor")
```

Output:

```
You didn't provide a name
Hello, Taylor!
```

## Implicitly unwrapped optionals

Sometimes we have a value that would start with `nil` and gets initialized before we start using it. Kinda like `late` properties in dart. These values can be marked as implicitly unwrapped optionals so that we don't have to deal with the possibility of `nil` everywhere we wanna use them since we're sure they will be initialized by that time.

```swift
var age: Int! = nil

// After some time
age = 33

print(age.isMultiple(of: 3))
```

Output:

```
true
```

> Note: Being implicitly unwrapped means that these values literally gets 'implicitly unwrapped' whenever they're used (as if we have put `!` after them). It depends on where we pass these values. Try passing an implicitly unwrapped value to a function with aparameter of type `Any` (like `print()` for example), the value won't be unwrapped as the parameter can accept optional values with no issues.

## Failable Initializers

We can make an initializer that might fail and return `nil`. We just have to use `init?()` instead of `init()` and the return type will become an optional of struct/class type.

```swift
class Person {
    var id: String

    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}

let person = Person(id: "123")

print(person?.id)
```

Output:

```
nil
```

## Type casting as optional

We can cast a value to another type using `as?` which would return a `nil` in case of failing.

```swift
class Person {
    var name = "Anonymous"
}

class Customer: Person {
    var id = 12345
}

class Employee: Person {
    var salary = 50_000
}

let customer = Customer()
let employee = Employee()
let people = [customer, employee]  //  An array of Person(s)

for person in people {
    if let customer = person as? Customer {
        print("I'm a customer, with id \(customer.id)")
    } else if let employee = person as? Employee {
        print("I'm an employee, earning $\(employee.salary)")
    }
}
```

Output:

```
I'm a customer, with id 12345
I'm an employee, earning $50000
```

## Pattern matching with `switch-case` and `enum` associated values

We can use `where` keyword with `switch-case` to match a specific case of an enum's associated value.

```swift
enum WeatherType {
    case sun
    case cloud
    case rain
    case wind(speed: Int)
    case snow
}

func getHaterStatus(weather: WeatherType) -> String? {
    switch weather {
    case .sun:
        return nil
    case .wind(let speed) where speed < 10:  // Focus on this syntax
        return "meh"
    case .cloud, .wind:
        return "dislike"
    case .rain, .snow:
        return "hate"
    }
}

getHaterStatus(weather: WeatherType.wind(speed: 5)) // meh
```

## Optionals are enums with associated values

Swift optionals are actually enums with two cases: `.none` and `.some`, where `.some` is the case of an existing value.

```swift
func knockKnock(_ caller: String?) {
    print("Who's there?")

    switch caller {
    case .none:
        print("* silence *")
    case let .some(person):
        print(person)
    }
}

knockKnock(nil)
knockKnock("Orange")
```

Output:

```
Who's there?
* silence *
Who's there?
Orange
```

## Copy on write in structs

Swift uses a technique called "copy on write" when making copies of struct instances. It means that when we assign an existing struct instance to a new variable (i.e, make a copy of it), Swift doesn't actually make a copy of the instance until we try to change its data, hence the name "copy on write".

## Working with Objective-C code

Objective-C was the main iOS dev language in the past, and it seems like some older APIs still use it, so to make some of our Swift code available to use by the OS we need to use the `@objc` mark with our code.

## Properties with getter only

If you use a computed property for reading only, you can omit the `get` keyword and closure.

```swift
struct Person {
    var age: Int

    var ageInDogYears: Int {
        age * 7
    }
}

var fan = Person(age: 25)

print(fan.ageInDogYears)

```

Output:

```
175
```

## View controller method overloading

In UIKit, it's not the method name that reflects its functionality but rather its parameters. For example, in `UITableViewController`, we have two methods named `tableView` that we can override to specify our tableview behavior.

```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    return cell
}
```

What makes them different is their parameters (method overloading):

- The first on is used for specifying the number of rows in a given table section (which is indicated in its `numberOfRowsInSection` parameter label)
- The other is used to build the cell to be viewed in a given row (which is indicated by its `cellForRowAt` parameter label).

## `@IBOutlet` and `@IBAction`

Both are ways of connecting "Interface Builder" to code. The difference is that `@IBOutlet` allows our code to trigger interface changes, while `@IBAction` allows our interface to trigger some code.

## `UIActivityViewController`

This view controller can be used to implement sharing functionality in iOS apps.

## `@IBAction` implies `@objc`

Apparently the `@IBAction` automatically implies `@objc` as well.

## Inheritence before conformance

If a class inherits from another and conform to protocol(s) at the same time, we write the superclass identifier first then the rest of the protocols.

```swift
class Superclass {
    //...
}

protocol Protocol1 {
    //...
}

protocol Protocol2 {
    //...
}

protocol Protocol3 {
    //...
}

class MyClass: Superclass, Protocol1, Protocol2, Protocol3 {
    //...
}
```

## Capturing in closures: strong vs weak vs unowned

By default, closures capture values used in them strongly which prevents them from getting destroyed. We can change that using `weak` keyword, which turns these captured values into optionals and allows them to get destroyed and set them to `nil` inside of closures.

Another alternative is `unowned` which is similar to `weak` but implicitly unwraps the captured values so we can use them without unwrapping them ourselves. This should be used very carefully.

## Strong reference cycles

Also known as retain cycles: two objects contain closures that reference each other and prevent themselves from getting destroyed, causing a memory leak. Consider the following two classes:

```swift
class House {
    var ownerDetails: (() -> Void)?

    func printDetails() {
        print("This is a great house.")
    }

    deinit {
        print("I'm being demolished!")
    }
}

class Owner {
    var houseDetails: (() -> Void)?

    func printDetails() {
        print("I own a house.")
    }

    deinit {
        print("I'm dying!")
    }
}
```

Both can hold a closure and both have deinitializers to let us know when they're destroyed. Here's how we could create a strong reference (retain) cycle:

```swift
print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = owner.printDetails
    owner.houseDetails = house.printDetails
}

print("Done")
```

Output:

```
Creating a house and an owner
Done
```

Notice how the deinitializers didn't run cause each instance strongly captures the other in its closure. To solve this, we can use a `weak` capture:

```swift
print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = { [weak owner] in owner?.printDetails() }
    owner.houseDetails = { [weak house] in house?.printDetails() }
}

print("Done")
```

Output:

```
Creating a house and an owner
I'm dying!
I'm being demolished!
Done
```

## Navigation Controllers ar placed inside Tab Bar Controllers

For some reason.

## `UIStoryboard`

Apparently you can have multiple storyboards in one app and can load them by making an instance of `UIStoryboard` and providing the storyboard name and the bundle that contains it.

> Passing `nil` as the bundle means "use the current app main bundle".

## Breakpoints

Breakpoints in XCode can be conditional, have actions, and be ignored a number of time before stopping execution. They're very powerful!

## Exception Breakpoints

We can specify (what seems like) a global breakpoint when an exception is raised, so that we can see the state of our app when it happens.

## Catch View Hirearchy

This is one of the debugging tools that allows us to see our current user interface compononets layered on top of each other in a 3D space so that we can better see what is and isn't there.

## `for case let` syntax

A loop that can filter elements. Can be used to typecast elements in a loop like so:

```swift
for case let label as UILabel in view.subviews {
    print("Found a label with text \(label.text)")
}
```

Only elements that are successfully typecasted to `UILabel` will be used in the loop body.

It can also be used to unwrap optionals and skip `nil` values in an array:

```swift
let names = ["Bill", nil, "Ted", nil]

for case let name? in names {
    print(name)
}
```

Output:

```
Bill
Ted
```

## `@unknown default` vs `default`

When dealing with an enum, using `default` in a switch case statement handles the case of value not matching any of our enum values. `@unknown` is used when we want to account for the case of adding new values to our enum in the future, as it will raise a warning if our switch statement isn't explicitly covering all our current enum values.

```swift
switch distance {
case .unknown:
    self.distanceReading.text = "UNKNOWN"

case .far:
    self.distanceReading.text = "FAR"

case .near:
    self.distanceReading.text = "NEAR"

case .immediate:
    self.distanceReading.text = "RIGHT HERE"

@unknown default:
    self.distanceReading.text = "WHOA!"
}
```

## Extensions on generic types

Consider the following case: we wanna make an extension that counts the number of odd and even numbers in an arbitrary collection. That said collection should contain only integer numbers for our extension to make sense. We can constraint our extension to only apply to collections whose generic `Element` type is a `BinaryInteger` like so:

```swift
extension Collection where Element: BinaryInteger {
    func countOddEven() -> (odd: Int, even: Int) {
        var even = 0
        var odd = 0

        for val in self {
            if val.isMultiple(of: 2) {
                even += 1
            } else {
                odd += 1
            }
        }

        return (odd, even)
    }
}
```

> Notice how `isMultiple(of:)` method is now available to call on our collection element. That's because we restricted this extension to only apply to collections whose elements are integers.

## Opaque return types

Sometimes the return type is quite long with a bunch of nested generic parameters, and the called doesn't really need to know all these details. We can try returning a protocol, but in some cases this won't be possible if some protocol APIs depends on the concrete type, like Equatable for example. In Equatable, the `==` operator is defined to have two operands of the type implementing the protocol (e.g Int, Double, etc), meaning that we can't use `==` between an Int and a Boolean, although they both are equatable.

So in this case, we can't hide the info of what type is returned and just say it's an Equatable, cause we can't compare any two Equatables. However we can say that the function will return `some Equatable` value of fixed type, e.g it will always return an Int, or it will always return a Double, etc. This way, we can compare the Equatable results returned from the function knowing that they will always be the same Equatable type, although we don't actually know what that type is. This means that the function should always return the same Equatable type, so this function will not compile:

```swift
var returnInt = true

func getRandomNumber() -> some Equatable {
    if (returnInt) {
        Int.random(in: 1...6)               // Error: Branches have mismatching types 'Int' and 'Double'
    } else {
        Double.random(in: 1...6)
    }
    
}
```

This behavior allows us to hide the type info from code but not from the compiler. It's used everywher in SwiftUI as views return `some View`. See this [article](https://www.hackingwithswift.com/quick-start/beginners/how-to-use-opaque-return-types) to know more about it.

## `while let`

Similar to how `if let` works, you can use `while let` to keep unwrapping an optional.

```swift
while let value = try? getNextValue() {
    print(value)
}
```

The loop will continue executing until `getNextValue` throws.

## `defer` keyword

`defer` is used to let some code run before existing a scope:

```swift
print("Step 1")

do {
    defer { print("Step 2") }
    print("Step 3")
    print("Step 4")
}

print("Step 5")
```

Output:

```
Step 1
Step 3
Step 4
Step 2
Step 5
```

You can read this [article](https://www.hackingwithswift.com/new-syntax-swift-2-defer) to know more about it.
