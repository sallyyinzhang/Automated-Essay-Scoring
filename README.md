# Automated Essay Scoring
To help human essay scoring, automated essaying processes are widely used. These systems are modeled with Artificial Intelligence which require significant amount of time and resources. In this paper, we are seeking a simpler model by combining Natural Language Processing and statistical modeling. Our natural language processing involves three steps: structure analysis, syntactic analysis and information extraction. With these three steps, our extracted features cover many characteristics of the essay. Then we feed these features into two statistical models, linear model (Linear Regression) and nonlinear model (Random Forest), to predict a testing set of essay. Given the simplicity of our approach, our predicted errors are between &plusmn;0.4 and &plusmn;0.7 for four different essay prompts. Even though a model with such prediction errors cannot completely replace human grading, but it provides possibilities to replace some parts of human grading to save resources.  

#License
The MIT License (MIT)

Copyright (c) 2015 Qiwei Li, Yin Zhang, Yining Liu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

