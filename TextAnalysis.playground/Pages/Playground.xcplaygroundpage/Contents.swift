/*:
 # Analyzing Natural Language
 You've just finished reading Mary Shelley's Frankenstein - one of the great horror books in the western canon. As you set the book aside, you wonder - what made the book so scary? Can you use  your programming knowledge to study the text and gleam some clues as to why it is so terrifying?
 
 We use language to communicate and do a diverse set of tasks in everyday life -- from simple tasks such as greeting others, asking and answering questions, to creative pursuits, like evoking horror and fear in a reader. Can we use programming and some simple statistics to understand how words come together to make something more than the sum of their parts? Yes you can! In this short playground, we will see how to analyze words in a text, thus giving us a small insight into how we use words to communicate and act.
 
 Let's go on to our first, and most important task - reading a text file into an object that we can then analyze later.

 ## Reading a text file
 
 Let us start by reading the text we wish to analyze - in this case Mary Shelley's **Frankenstein** - into our program. A text file is a really long string file, so we  can read in the file and simply store it in a `String` constant.
*/
import Foundation


// First, we look for the location of our file - frankenstein.txt
let filepath = Bundle.main.path(forResource: "frankenstein", ofType: "txt")!

// Now that we have the location of our file, we load the contents of the file into a constant object
let fileContents = try String(contentsOfFile: filepath)
/*:
 Great! As you can see from the output, we now have read the file and stored it in the constant **fileContents**. However, look at the text a litte deeper. Sometimes text files contain metadata which isn't relevant to our task - who produced the text, the date, the language and many other details. See if you can find where the book actually starts by looking at the beginning of the book:
*/
fileContents.prefix(800)

/*:
 Similarly look at the end of the book - is there a point where you can find the book ends, and the rest is not interesting to our analysis?
*/

fileContents.suffix(19100)

/*:
 It is clear that the text that we should only be interested in analysing text between these two lines: `*** START OF THIS PROJECT GUTENBERG EBOOK FRANKENSTEIN ***` and `*** END OF THIS PROJECT GUTENBERG EBOOK FRANKENSTEIN ***`. So, before we move on, let us constrain our **fileContents** constant to only contain those elements between those two lines
*/

let startString = "*** START OF THIS PROJECT GUTENBERG EBOOK FRANKENSTEIN ***"
let endString = "*** END OF THIS PROJECT GUTENBERG EBOOK FRANKENSTEIN ***"

// Find index in string where startString ends
let beginning = fileContents.endIndex(of: startString)!

// Find index in text where endString begins
let ending = fileContents.index(of: endString)!

// Get the bookcontents between the end of startString and beginning of endString
let bookContents =  String(fileContents[beginning..<ending])

/*:
 We now have the contents of the book.
 
 * Callout(Try it yourself):
 You might notice that our `bookContents` object still contains some content that is not relevant to our analysis - the table of contents for instance is still in the beginning. See if you can modify the `startString` and `endString` above so that we load text starting from *Chapter 1*, and ending with the final lines of the book. You can look into the text file *Frankenstein* which is in the Resources folder to understand the layout of the book better.
*/

/*:
## Getting Words
 We have read the text file containing the novel and stored it in a `String` constant. We can now use our programming skills to do whatever we want with the text. A natural place to start with English text is to analyse *words* and how often they occur in the text.
 
 But it looks like we're not done getting our text just the way we want it for analysis.  Before moving on, you will notice that there are a lot of weird characters that don't look like alphabets: *\n*, *\r* and many others. These special characters are how computers understand non-letter symbols in texts - a newline, a tab or a special symbol. In addition, there are also commas, periods, and many other symbols. Let us remove all non-alphabetical characters from `bookContents`, and create an array of only the *words* in our text.
 
 We do this by *splitting* our book contents where ever we see fit. Splitting just means the text is divided into pieces at certain characters. For example, splitting the string `'I like dogs'` only at spaces would give us the list `['I', 'like', 'dogs']`.
 
 I have written code to separate our bookContents at *spaces*, *commas* and some special characters. Can you think of some other characters where you'd like to split our text into words (and thus remove from further analysis)? Go ahead and add them to the array below.
*/

var words = bookContents.components(separatedBy: [" ", ",", "\n", "\r", "\t"])

/*:
 We are not out of the woods yet - You'll notice a lot of empty `""` elements in your array of words. Let's remove them from our array.
 */

words.removeAll(where: {(word) in word == ""})
words

/*:
 We finally have an array of words from the novel `Frankenstein`. Before we move on to our analysis, I would like to do one more step to clean up our words - lowercasing all the characters in our words. Why do we do this? For most purposes, there is very little difference between *apple* and *Apple*, but currently, our program sees them as two different words. The following code block lowercases all the words in our array `words`
 
  - Important:
  While it seem like getting our text ready for analysis is taking a lot of time, it is essential to prepare your text into a format that is suitable for further processing. This is essential to any good analysis of any data, but especially text. This step is called **preprocessing**
 */

words = words.map {word in word.lowercased()}

/*:
  Now that we finally have a list of all the words in the novel *Frankenstein*, we can finally get around to answering our question - what made the book so scary? Can looking at patterns within the words give us an idea?
 
 * Callout(Try it yourself):
 What happens if we *don't* lowercase all the words in the text? Try all the code that follows with non-lowercased words and compare the results with lowercased words
 */

/*:
 ## Counting words
 Let's try something simple - let us count how many times each word occurs in the novel. Perhaps scary words are more common than happy words?
 
 To count the number of occurences of each word in our array `words`, we will create a dictionary where every unique word is associated with a value - in this case, the number of times it occurs in our text. There are many ways to do this - see if you can understand the logic behind the following two statements by looking into the documentation of the `map` method and the `Dictionary` type.
 - Important:
 You will always run into instances where some programming statement makes no sense to you. Documentation is your friend here - always refer to the documentation first to understand how the statement works. If you still have issues, you can always search the web.
 */

let wordTuples = words.map { word in (word, 1) }
let wordFrequency = Dictionary(wordTuples, uniquingKeysWith: +)

/*:
 Let's look at our various aspects of our text. How many unique words do we have in *Frankenstein* approximately?
 */

wordFrequency.count

/*:
 That's a pretty big vocabulary. What's the word that occurs most often?
*/

let mostFrequentWord = wordFrequency.max { a,b in a.value<b.value }
mostFrequentWord

/*:
 That's not very interesting, but we should have expected that words like *the*, *a*, *in*, *on* and so forth would occur very highly in any English book. But what about words that evoke fear? Let us look at the number of times the following words occur in *Frankenstein*:
 */

// Make a list of scary words
let scaryWords = ["wretched", "unfortunate", "horrible", "darkness", "miserable", "sad", "unhappy"]

// Make an empty dictionary to store counts of our scary words
var scaryWordsFrequency: [String: Int] = [:]

// Build dictionary of counts for our scary words
for word in scaryWords {
    scaryWordsFrequency[word] = wordFrequency[word]
}
scaryWordsFrequency
/*:
 We can see that certain scary words are more common than others, and these words do seem to occur quite often in the novel. However, can we say that *Frankenstein* contains more scary words solely based on this? **No**
 
 To conclude that *Frankenstein* contains more scary words, you need to ask, **more than what?**. Counts on their own are not very informative. If we can show that the number of scary words are (usually) more than the number of happy words, then perhaps we can conclude that scary words are used more often in *Frankenstein* than happy words.
 
 I've put in 2 happy words - add in your words that you associate with happiness and joy and check how often they occur in *Frankenstein*.
 */

// Make a list of happy words
let happyWords = ["happy", "beautiful"]

// Make an empty dictionary to store counts of our scary words
var happyWordsFrequency: [String: Int] = [:]

// Build dictionary of counts for our scary words
for word in happyWords {
    happyWordsFrequency[word] = wordFrequency[word]
}
happyWordsFrequency

/*:
 What can you say now looking at the counts of scary and happy words? Do all scary words occur more often than happy words? Or is the answer more complicated? Why does the word *miserable* occur so often in *Frankenstein*? Is it because our protagonist Victor Frankenstein is miserable following the events in the book?
 
 These are all good questions and should teach you an important lesson about analysing data. It is up to you to deduce the right reasons for why the data is the way it is, and there are many possible interpretations of the data you obtain from analysis. Finding the right explanation for the data(or the best one if there isn't a right one) may require more analyses, and perhaps technqiues outside the scope of this short playground tutorial. This playground's purpose was to show you what is possible with textual analysis - go ahead and see what else you can do with the code blocks above!
 
 * Callout(Try it Yourself):
 Another way to see if scary words are used more often in *Frankenstein* is to compare it against a book that isn't usually considered scary. I've include Jane Austen's *Pride and Prejudice* with this playground - you can load it by using the following filepath:
     ```
     let filepath = Bundle.main.path(forResource: "prideandprejudice", ofType: "txt")!
     ```
     What are the counts of words in that book? Is it reasonable to just compare the counts of words in books of different lengths? How can you change the frequency of words in books so that they can be compared against each other? **Hint: you need to divide the count by a number. What number?**
 */

/*:
## Moving Forward
 Congratulations! You've made small but important steps towards using your knowledge of programming to gain an understanding of natural language. We have seen how to read in the text file for a novel, and to count occurences of unique words in the novel.
 
 With these basic tools, you can now explore the world of statistical analysis of text. Perhaps you're interested in [analyzing sentiment](https://en.wikipedia.org/wiki/Sentiment_analysis) of phrases, or perhaps you would like to find words in a text that are more likely to [occur together](https://en.wikipedia.org/wiki/N-gram) . Whatever may be the case, I hope that I've piqued your interest into studying natural language using math and computers. Thank you for your time!
 
## Acknowledgments
This short playground was inspired by an assigment in Prof. Katrin Erk's *Analysing Linguistic Data* course at the University of Texas at Austin - for which I was the TA. Katrin and I share the same goal of helping students to be successful in using programming to achieve their goals, and her passion for teaching inspired me to see if I could build a Swift Playground that could illustrate that programming can teach us interesting things about language. Thank you Katrin.

I would also like to thank Paul Hudson at [Hacking with Swift](https://www.hackingwithswift.com) whose tutorials have been immensely useful to me for learning Swift programming.

The text files for *Frankenstein* and *Pride and Prejudice* were obtained from [Project Gutenberg](https://www.gutenberg.org) which provides copyright free eBooks for free use.
 
*/

