# Source of Hugo Blog

In my blog post [How to Set Up This Blog](https://kpwn.de/2021/09/how-to-set-up-this-blog/), I explain how to undertake extensive customization to the layout and other components of a Hugo blog. A reader had trouble to rebuild their blog just by following my instructions and asked whether I could make the source code public. So here it is.

## Setup

1. Clone this repository:
```
git clone git@github.com:KwnyPwny/hugo-blog.git
cd hugo-blog
```

2. Clone PaperMod:
```
cd themes
git clone git@github.com:adityatelange/hugo-PaperMod.git
```

3. Clone MathJax:
```
cd ..
git clone git@github.com:mathjax/MathJax.git
```

4. Run:
```
hugo server -D
```

## Credits

My local `themes/hugo-PaperMod` folder contains the awesome [PaperMod theme](https://github.com/adityatelange/hugo-PaperMod) by Aditya Telange.

My local `MathJax` folder contains the math display engine [MathJax](https://github.com/mathjax/MathJax).
