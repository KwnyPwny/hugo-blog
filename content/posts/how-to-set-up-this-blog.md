---
title: "How to Set Up This Blog"
# description: "Description" # If this is set, it is preferred to the summary in the <meta name="description" tag>
summary: "This post explains how to undertake extensive customization to the layout and other components of a Hugo blog. It starts out with the basic setup and finishes with the final deployment." # The summary is displayed in the posts overview only
# tags: ["Hugo", "Blog", "Custom Theme"] # google does not use these
draft: false
date: 2021-09-06T00:00:00+02:00
# creationDate: 2021-08-23T22:49:31+02:00
# weight: 1
# showToc: true
# tocOpen: false
# hidemeta: true
# hidesummary: true
# searchHidden: true
images:
    - "/img/1/twitter-card.png"
---

The most difficult part of starting a blog is writing the first post.

While setting up this blog, I came up with the idea to document my steps into the very first blog post.
So here it is.

## Choosing a Blogging Platform
There are loads of blogging platforms.
The most popular probably is WordPress.
Being a penetration tester, my demands to a blogging platform might differ from those of the majority of bloggers.
I want my blog to be:
* easy to maintain regarding software updates
* simple in its functionality
* easy for me to setup
* transparent in what is going on under to hood

As I do not need any interactive elements, the most suitable solution is a *static site generator*.
Those simply create static HTML files from the provided sources.
I found a nice comparison on [jamstack.org](https://jamstack.org/generators/):
{{< figure src="/img/1/overview.png" align="center" caption="The comparison of static site generators on jamstack.org" border="white" >}}
At the time of my research, [Hugo](https://gohugo.io/) was the most starred static site generator on GitHub that's not written in JavaScript - so I went for it.

## Installing Hugo
Running a Linux distribution that supports Snaps, it is very easy to install Hugo:
```
snap install hugo
```

Debian derivatives can also install Hugo via their package manager.
However, this method is *not recommended* because the version is usually outdated.
I could confirm this, by comparing the version from the Ubuntu focal repository to the latest version on GitHub (`v0.87.0`):
```
apt search hugo
  [...]
  hugo/focal 0.68.3-1 amd64
  [...]
```

**Note:** Using the latest version is an advantage when choosing a theme in the next step.
Many themes require a minimum Hugo version.

## Getting Started
Hugo has a great [getting-started](https://gohugo.io/getting-started/quick-start/) guide but I did not follow it step-by-step.
Here's what I did:
```
hugo new site blog -f yml
cd blog
```
The `-f yml` flag changes the configuration file format from the default value TOML to YAML.
This is just a matter of preference.

Now comes the worst part: Choosing a theme.
Actually, it took longer to decide which theme to use than writing this blog post.

An official list of themes can be found at [themes.gohugo.io](https://themes.gohugo.io/).
I'll spare you with the details of my decisioning and present the result right away: [PaperMod](https://github.com/adityatelange/hugo-PaperMod).
I liked its simplicity and the support of both, dark and light mode.
The required minimum version of Hugo is `v0.82.0`.

In order to install the theme, I cloned the GitHub repository and copied the example `config.yml` from [here](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation#sample-configyml).

```
git clone https://github.com/adityatelange/hugo-PaperMod themes/PaperMod
```

**Note:** There is an example site in the `exampleSite` branch of the repository.
However, the contents of its `config.yml` seem to be a bit outdated.

By running the following command, a local Hugo server can be started.
The `-D` flag includes posts that are marked as *draft*.
```
hugo server -D
```

The result can already be viewed by visiting `http://localhost:1313` in a browser:
{{< figure src="/img/1/blog-1.png" align="center" caption="A first look at the freshly created blog" border="white" >}}

New pages can be created with the `hugo new` command.
I created an *About* page first:
```
hugo new about.md
```

The server automatically rebuilds the site when it detects changes.
This makes the new page accessible on `http://localhost:1313/about`.

**Note:** The source files are written in Markdown, a lightweight markup language.
A great overview of Hugo's Markdown elements can be found on [Markdown Guide](https://www.markdownguide.org/tools/hugo/).

## Customizing the Theme

The main configuration is done within the `config.yml` file.
I am not going to explicitly list the changes I made, as this seems quite lengthy and boring.
Instead, I will explain how to make layout changes that are not configurable via `config.yml`.

**Update from May 14, 2023**:
I recommend reading the following sections to get a deeper understanding of Hugo themes and layouts.
However, if you are only interested in the end result, you can get a copy of this blog [on GitHub](https://github.com/KwnyPwny/hugo-blog).

### Social Icons
As you can see in the screenshot above, the social icons of this layout are usually located on the starting page.
I wanted my starting page to contain a list of posts instead, so I had to move the social icons somewhere else.
I decided to put them in the footer of the page.
Social icons are defined inside the `config.yml` as follows[^4]:
```yml
params:
    socialIcons:
        - name: email
          url: "mailto:blog@kpwn.de"
        - name: twitter
          url: "https://twitter.com/kwnypwny"
        - name: github
          url: "https://github.com/KwnyPwny"
        - name: RSS
          url: "/posts/index.xml"
```

[^4]: Update from December 29, 2022: I have added a link to my Mastodon profile, by simply adding this to the `socialIcons` list:
    ```yml
            - name: mastodon
              url: https://infosec.exchange/@kpwn
    ```
    Note that this already suffices to add a *verified link* to the blog from your Mastodon profile.

To find out where this variable is referenced I used `grep`:
```zsh
grep -ir "socialicons"
```

This is going to list all files in the current working directory and all of its subdirectories (`-r`) containing the string `socialicons`.
`-i` makes the search case insensitive. The results are:
```
themes/PaperMod/layouts/partials/templates/schema_json.html:      {{ range $i, $e := .Site.Params.SocialIcons }}{{ if $i }}, {{ end }}{{ trim $e.url " " }}{{ end }}
themes/PaperMod/layouts/partials/index_profile.html:        {{- partial "social_icons.html" $.Site.Params.socialIcons -}}
themes/PaperMod/layouts/partials/home_info.html:        {{ partial "social_icons.html" $.Site.Params.socialIcons }}
```

The second and third file seem to be what we are searching for.
As we can anticipate, a *partial* called `social_icons.html` is created.
Partials are smaller components that can be embedded into templates.

{{% excursion anchor="excursion" title="Excursion: Go Templates and Partials" %}}

Hugo uses [Go Templates](https://gohugo.io/templates/introduction/) to embed dynamic elements into HTML templates.
Let's understand how the social icons are displayed on the homepage:
```go-html-template
{{ partial "social_icons.html" $.Site.Params.socialIcons }}
```

* Go Template variables and functions are accessible within `{{ }}`.
* The `partial` function has the following syntax: `partial "<PATH>/<PARTIAL>.html" .`
  * `"<PATH>/<PARTIAL>.html"` is the relative[^1] path and name of the partial.
  * `.` is called *the dot* and gives the partial context.

[^1]: There are two lookup folders for partials in Hugo:  
    1. `layouts/partials/*<PARTIALNAME>.html`
    2. `themes/<THEME>/layouts/partials/*<PARTIALNAME>.html`  

    The `partials` directory may contain subdirectories which build the `<PATH>` of the partial.

So the above code passes our map of social icons from the `config.yml` as context to the `social_icons.html` partial.
Let's take a look at `themes/PaperMod/layouts/partials/social_icons.html`:
```go-html-template
<div class="social-icons">
    {{- range . }}
    <a href="{{ trim .url " " }}" target="_blank" rel="noopener noreferrer me" title="{{ .name | title }}">
        {{ partial "svg.html" . }}
    </a>
    {{- end }}
</div>
```

* The `range` keyword is used to iterate over data structures. The `end` keyword defines where the loop ends.
In this case the data to iterate is *the dot*, i.e. the context we passed to the partial.
* The `.url` and `.name` values of our icons are put inside an HTML hyperlink.
* Another partial `svg.html` is called with *the dot* as context.
Within loops, *the dot* has the value of the current item.

So let's finally take a look at `themes/PaperMod/layouts/partials/svg.html`:
```go-html-template
{{- $icon_name := ( trim .name " " | lower )}}
[...]
{{- else if (eq $icon_name "email") -}}
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 21" fill="none" stroke="currentColor" stroke-width="2"
    stroke-linecap="round" stroke-linejoin="round">
    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
    <polyline points="22,6 12,13 2,6"></polyline>
</svg>
{{- else if (eq $icon_name "facebook") -}}
[...]
```

* As we see the `.name` of the social icon is used to define the variable `icon_name`.
* The partial then defines SVGs, i.e. the icons that are displayed.
* By using the conditional statements `if` and `else`, exactly the one SVG is displayed which matches the name of the social icon.

**Note:** I did not know all of the above when setting up the blog.
Basically, it is enough to know that the statement `{{ partial "social_icons.html" $.Site.Params.socialIcons }}` somehow embeds the social icons that are defined in the `config.yml`.

{{% /excursion %}}

The footer of the page also is a partial.
It is defined in `themes/PaperMod/layouts/partials/footer.html`.
Hugo allows us to define our own partials.
If such a partial has the same name as an existing partial, the latter is overridden.
So first, I copied the existing footer partial:
```
cp themes/PaperMod/layouts/partials/footer.html layouts/partials/
```

In order to display the social icons there, I added the partial code from above.
The resulting `footer.html` looks like this:
```go-html-template {hl_lines=[2]}
<footer class="footer">
    {{ partial "social_icons.html" $.Site.Params.socialIcons }}
    {{- if .Site.Copyright }}
    <span>{{ .Site.Copyright | markdownify }}</span>
    {{- else }}
    [...]
```

The result looks as follows:
{{< figure src="/img/1/blog-2.png" align="center" caption="Social icons in the footer" border="white" >}}

The icons are at the right spot, but there are two problems:
1. The footer seems to have a CSS setting that underlines links. This looks nice for text links but weird for the icons.
2. Although the browser windows is large enough to display everything, a scroll bar is displayed such that the header and footer are not visible at the same time.

Using the *Developer Tools* of my browser, I found out that links inside the footer have the property `border-bottom: 1px solid var(--secondary)`.
I did not want to manipulate the CSS files themselves, so I decided to copy the `social_icons.html` partial and add `style="border-bottom: none;"` to the link definition.
This removes the underline.

The second problem was a little more complex.
The height of footer and header seem to be predefined by the theme inside the file `themes/PaperMod/assets/css/core/theme-vars.css`.
The minimum height of the main class is calculated with these values.
However, we changed the real size of the footer by adding the social icons.
With a little fiddling I found that the scroll bar disappears when `--footer-height` is changed from 60px to 97px.
Additionally, I had to adjust the padding values of the footer and social icons.
I did this directly in the partial files by adding `style="padding: ..."` to the HTML tags.

Using the same techniques, I moved the button that toggles between dark and light mode to the very right of the header.

### Shortcodes
Another really useful feature of Hugo are [shortcodes](https://gohugo.io/content-management/shortcodes/).
A shortcode is a snippet inside a content file that Hugo will render using a predefined template.
They can be used when plain Markdown is not enough.
Basically, shortcodes are the equivalent of partials but not for templates but content files.

#### Captions for images
As you might have noticed, the images within this blog post have a caption that briefly describes their content.
Usually, Markdown does not support this.
But Hugo has a built-in shortcode for this, called `figure`.
It can be used like this:
```
{{</* figure src="/media/spf13.jpg" title="Steve Francia" */>}}
```

The PaperMod theme already overrides this shortcode with the custom file `themes/PaperMod/layouts/shortcodes/figure.html`.
Let's take a look to understand what is going on:
```go-html-template
<figure{{ if or (.Get "class") (eq (.Get "align") "center") }} class="
           {{- if eq (.Get "align") "center" }}align-center {{ end }}
           {{- with .Get "class" }}{{ . }}{{- end }}"
{{- end -}}>
    {{- if .Get "link" -}}
        <a href="{{ .Get "link" }}"{{ with .Get "target" }} target="{{ . }}"{{ end }}{{ with .Get "rel" }} rel="{{ . }}"{{ end }}>
    {{- end }}
    <img loading="lazy" src="{{ .Get "src" }}{{- if eq (.Get "align") "center" }}#center{{- end }}"
         {{- if or (.Get "alt") (.Get "caption") }}
         alt="{{ with .Get "alt" }}{{ . }}{{ else }}{{ .Get "caption" | markdownify| plainify }}{{ end }}"
         {{- end -}}
         {{- with .Get "width" }} width="{{ . }}"{{ end -}}
         {{- with .Get "height" }} height="{{ . }}"{{ end -}}
    /> <!-- Closing img tag -->
    {{- if .Get "link" }}</a>{{ end -}}
    {{- if or (or (.Get "title") (.Get "caption")) (.Get "attr") -}}
        <figcaption>
            {{ with (.Get "title") -}}
                {{ . }}
            {{- end -}}
            {{- if or (.Get "caption") (.Get "attr") -}}<p>
                {{- .Get "caption" | markdownify -}}
                {{- with .Get "attrlink" }}
                    <a href="{{ . }}">
                {{- end -}}
                {{- .Get "attr" | markdownify -}}
                {{- if .Get "attrlink" }}</a>{{ end }}</p>
            {{- end }}
        </figcaption>
    {{- end }}
</figure>
```

Wow, that are a lot of brackets.
To understand the base construct, I removed all of the Go Templates.
This leaves us with simple HTML:

```html
<figure class="align-center">
  <a href="" target="" rel="">
    <img loading="lazy" src="#center" alt="" width="" height=""/>
  </a>
  <figcaption>
    <p>
      <a href=""></a>
    </p>
  </figcaption>
</figure>
```

As we can see, a `<figure>`-tag is used that itself among others contains the actual `<img>`-tag and a `<figcaption>`-tag for the caption.
The values are populated by evaluating the parameters that the shortcode is called with.

Now, that we understood how shortcodes work, we can easily adapt them to our needs.
I thought, it would be nice to put a border around images.
This helps to set apart the images from the background if they have similar hues.

To achieve this, I copied the shortcode to `layouts/shortcodes/figure.html` and added the following line at the end of the `<img>`-tag definition:  
```go-html-template
{{- with .Get "border" }} style="border: 2px; border-style: solid; border-color: {{ . }}"{{ end -}}
```

Now, I can embed images with a border of arbitrary color like this:
```
{{</* figure src="/img/1/blog-2.png" align="center" caption="Social icons in the footer" border="white" */>}}
```

#### The Excursion Shortcode
In the section about social icons, I added an [excursion]({{< relref "#excursion" >}}) that is not required to understand or follow this blog post.
I wanted this excursion to be collapsible, such that its optional nature is obvious to the reader.
A collapsible element does not disturb the flow of reading but can be placed exactly where the information fits.
Luckily, there is already an appropriate element on this page that we can adapt to our needs: The table of contents.

This is implemented in the partial `toc.html`.
I copied it to my shortcodes folder and named it `excursion.html`.

**Note:** Shortcodes can be configured to require a *closing shortcode*. In contrast to the `figure` shortcode from above, these are called as follows:
```
{{</* testshortcode parameters */>}}
content
{{</* /testshortcode */>}}
```

With everything we have learned up to now, the changes to the shortcode file are quite obvious.
I deleted all of the logic that is necessary to create the table of contents and just kept the base HTML construct.
I added support for two parameters:
* `anchor` is used for cross references within the document. This enables me to link to the excursion as done above.
* `title` is the title of the excursion, which also is displayed when the element is collapsed.

What's still missing is the content of the excursion.
For shortcodes that require a closing tag, the content is populated with the `{{ .Inner }}` variable.
The result looks as follows:

```go-html-template
<div id="{{ .Get "anchor" }}" class="toc" style="margin-bottom: 20px; background: var(--theme);">
<details>
    <summary>
        <div class="details">{{ .Get "title" }}</div>
    </summary>
<div class="inner">
{{ .Inner }}
</div>
</details>
</div>
```

We can now use this shortcode to create the following [example]({{< relref "#excursion-demo" >}}):
```
{{%/* excursion anchor="excursion-demo" title="Excursion Demo" */%}}
This is an example
{{%/* /excursion */%}}
```

{{% excursion anchor="excursion-demo" title="Excursion Demo" %}} This is an example {{% /excursion %}}

### Syntax Highlighting

Hugo uses [Chroma](https://github.com/alecthomas/chroma) for syntax highlighting.
The PaperMod theme allows to use [Highlight.js](https://github.com/highlightjs/highlight.js/) alternatively.
I decided to stay with Chroma in order to reduce JavaScript dependencies.

PaperMod has a brief guide how to use Chroma in their [FAQ](https://github.com/adityatelange/hugo-PaperMod/wiki/FAQs#using-hugos-syntax-highlighter-chroma).
I followed the steps but could not get the feature to highlight specific lines to work.
Thus, here is my own quick guide:

1. In `config.yml` use at least the following entries:
  ```yml
  params:
      assets:
          disableHLJS: true
  # pygmentsUseClasses: false # you can remove this, just ensure it's not true
  markup:
      highlight:
          noClasses: true
          style: monokai # choose any style you wish
  ```

2. Remove or comment out the `!important` rule in the following block of `themes/PaperMod/assets/css/common/post-single.css`. The result looks like this:
```yml
.post-content .highlight span {
  background: 0 0; /* !important; */
}
```

I myself do not like to make changes directly to the CSS of the theme but couldn't find a better option.
Highlighted lines now look like this:
```text {hl_lines=[2]}
not highlighted
highlighted
```

**Note:** The highlighting of lines including line numbers still does not work as intended. 
There is an ugly spacing issue that I couldn't resolve without major alterations, which I considered not being worth the gain.
If anyone has a clean fix for this, I am happy to hear about it.

## Search Functionality
PaperMod comes with a *Search* functionality.
It is based on [Fuse.js](https://fusejs.io/) a lightweight JavaScript library.
In theory, this is very easy to setup by following the official [guide](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-features/#search-page).

### How It Works
By adding JSON output to the `config.yml`, the template `themes/PaperMod/layouts/_default/index.json` is populated with the title, content, permalink and summary of all pages.
The file is made available in the web root.

The layout for the search page itself is defined in `themes/PaperMod/layouts/_default/search.html`.
The according JavaScript is defined in `themes/PaperMod/assets/js/`.
The file `fastsearch.js` takes the `fuseOpts` parameters from `config.yml` to initialize the Fuse.js object and sends an XMLHttpRequest to `/index.json` to fetch the search index.
Every time a character is typed into the search field, a search is executed.

### Fuse.js Options
The PaperMod guide recommends a set of options that does not work well for pages that have more than 400 characters.
This is, because Fuse.js searches for patterns in a certain range of the text.
The range is defined via three parameters:
* `location`: The expected location of the pattern in the text
* `distance`: The allowed distance of the pattern to the expected location
* `threshold`: A multiplier to the `distance` value

The combination of `location: 0`, `distance: 1000` and `threshold: 0.4` narrows the search to the first 400 characters.
I would instead recommend the following options:
```yml
params:
    fuseOpts:
        ignoreLocation: true
        keys: ["title", "permalink", "summary", "content"]
```

Hereby the location of the pattern in the text does not matter at all.
However, I am not sure how this impacts the search performance if the index is large.

### A Hidden Bug

**Note [October 31, 2021]:** The bug described in the following was fixed with commit [d81b87](https://github.com/adityatelange/hugo-PaperMod/commit/d81b87938bd6a6c7812f63a40871c6e7516b126e).

Having everything set up, I recognized that the search was not working as expected.
Some terms, like `Hugo`, did not return any hits, others, like `Blog`, did.

I took a closer look at `themes/PaperMod/assets/js/fastsearch.js` and used `console.log()` to add some kind of debugging statements to the code, however could not find an obvious bug.
The [Live Demo](https://fusejs.io/demo.html) of Fuse.js really helped a lot for sanity checks.
It confirmed that my configuration parameters should actually work.

Finally, I decided to take a look at the `fuse` object in the JavaScript by adding another log statement as follows:
```js {linenos=true,linenostart=61,hl_lines=[5]}
// execute search as each character is typed
sInput.onkeyup = function (e) {
    // run a search query (for "term") every time a letter is typed
    // in the search box
    console.log(fuse)
    if (fuse) {
      [...]
```

Whenever a character is typed, this function triggers and prints the `fuse` object to the console.
I inspected the object in the *Console* of my browser's *Developer Tools*.

{{< figure src="/img/1/search.png" align="center" caption="The `fuse` object right before a search is executed." border="#1d1e20" >}}

The problem is easy to overlook: The option `ignoreLocation` is set twice, once in lower case and once in camel case.
The parameters from Hugo's `config.yml` are always stored as lower case but can be accessed with any case.[^2]
However, Fuse.js requires options to be in camel case.[^3]
This mismatch resulted in my configuration not being applied.
I filed a [bug report](https://github.com/adityatelange/hugo-PaperMod/issues/556) and provided a quick fix that stores lower case options into a predefined dictionary with camel case options.

[^2]: This is discussed here: https://discourse.gohugo.io/t/config-params-should-be-all-lowercase-or-not/5051
[^3]: This is not explicitly stated but options are defined here: https://fusejs.io/api/options.html

## Deployment
Now that everything meets our expectations, we can build the static pages by calling:
```
hugo -D
```

This will create a `public` directory inside Hugo's root folder.
The contents of this directory can simply be copied to the web root of the server with a file transfer protocol like SFTP.
However, before doing that, I would like to do a bit of preprocessing.

### EXIF Information
Image files often contain EXIF metadata.
These consist of information like date and time of creation, the GPS location where the image was created and the device or software the image was created with.
In order to remove the EXIF information `mogrify` can be used.
It is part of the `imagemagick` package.
Execute the following:
```zsh
mogrify -strip /path/to/img.png
```

### Spellchecker
To remove spelling errors, I like to use the spell checker `aspell`.
It comes with support for different languages and file types, including Markdown.
It also allows the definition of custom word lists.
This is very useful when using technical words that are not within conventional dictionaries.
I am executing it as follows:
```zsh
aspell --mode=markdown --lang=en --extra-dicts=$(pwd)/aspell.dict check /path/to/file.md
```

The `aspell.dict` must have the following format:
```text {hl_lines=[1]}
personal_ws-1.1 en 50
Chroma
creationDate
EXIF
hidemeta
hidesummary
// more words
```

The first line is important.
`en` is the language of the words and `50` the number of the words in the list.
The number does not have to be accurate.
The following lines simply contain the words.

### Automation
In order to automate the above steps, I created a shell script `prepare.sh` that runs the commands:
```zsh
#!/bin/zsh

## Remove EXIF Information From Images
find static/img -type "f" -exec mogrify -strip {} \;

## Spellchecker
cwd=$(pwd)
find content/posts/ -type "f" -name "*.md" -exec aspell --mode=markdown --lang=en --extra-dicts=$cwd/aspell.dict check {} \;

## Build
hugo -D
```

I made the file executable `chmod +x prepare.sh` and ran it `./prepare.sh`.

## That's it!

I hope you've learned something and I am happy to answer any questions via email or Twitter.
Have a great day.
