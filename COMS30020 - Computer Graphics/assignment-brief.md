# Computer Graphics Coursework Assignment Brief

## Introduction

This document provides an overview of the coursework assignment for the Computer Graphics unit.

The deadline for submission of all optional unit assignments is 13:00 on Thursday 7th of
December (the University discourages Friday deadlines !). Students should submit all required
materials to the "Assessment, submission and feedback" section of Blackboard - it is essential
that this is done on the Blackboard page related to the "With Coursework" variant of the unit.

Each Monday at 1-3pm during the coursework period there will be an online support session on Teams.
This session is for high-level Q&A regarding the nature and intent of the assignment and as such
is NOT intended to be a "debugging service" - if you are having problems getting your code to run
you should use the usual Teams discussion forum channel.

This coursework is an individual piece of work. You should therefore not collaborate with
other students - if you do, this will be considered as an academic offence and will be dealt
with in accordance with university plagiarism processes.

You are expected to work on both of your optional unit courseworks in the coursework
period as if it were a working week in a regular job - that is 5 days a week for no more than
8 hours a day. The effort spent on the assignment for each unit should be approximately equal,
being roughly equivalent to 1.5 working weeks each. It is up to you how you distribute your
time and workload between the two units within those constraints.

You are strongly advised NOT to try and work excessive hours during the coursework period:
this is more likely to make your health worse than to make your marks better. If you need
further pastoral/mental health support, please talk to your personal tutor, a senior tutor,
or the university wellbeing service.

## Assignment Overview

The aim of this unit has been to provide you with an understanding of a variety of different
approaches to 3D rendering. Pre-recorded lecture segments and narrated animations have provided
the main theoretical content of this unit and the tasks from the weekly workbooks have allowed
you to practically explore the key concepts that have been covered.

The assignment for this unit provides an opportunity for you to demonstrate your understanding
of these concepts, as well as a chance to exercise the codebase that you have been accumulating
over the course of the unit.

Many of the approaches to rendering that we have explored can only be fully appreciated by the
movement of the camera through/around a model. For this reason, your task is to create a short
(approximately 15 second) animated "ident" video. For more insight into the concept of an "ident",
you should view this [compilation of BBC2 idents](https://www.youtube.com/watch?v=nPnXQMlq2iM).
Note that there are a wide variety of examples presented in this video - some are more relevant
to this unit than others !

To provide a focus and purpose for your animation, you should create an ident for promotional
use by the [MVB hackspace](https://www.facebook.com/groups/363509640788223/)

We have provided a texture-mapped hackspace logo which you may like to use to help you on your
way. This however is not mandatory and you are free to use any alternative models you see fit.

## Assignment Details

The aim of this assignment is to refine and extend the codebase that you have developed during
the completion of the weekly workbooks, in order to build a fully functioning C++ renderer.
You should maintain and update your GitHub repository throughout this assignment. We will use
this to monitor your progress and the evolution of your code over the course of the assignment
(the journey is often as important as the final destination !). You must also submit the final
version of your code to Blackboard so that we can verify the correct implementation of particular
rendering features.

You MUST ensure that your animation clearly demonstrates _all_ of the rendering approaches that
you have implemented. If we can't see the feature operating correctly, then we can't award marks
for it. Note that you may find some features of your renderer can only be fully demonstrated
using certain modes of rendering (wireframe/rasterising/raytracing) so you may need to switch
between these during your animation.

If you wish to attain a high mark, you should attempt to implement some of the approaches
introduced in the "advanced topics" workbook. It is up to you to select which approaches you
implement, however you should remember that there is a performance trade-off at work. The
more complex the features you implement, the longer will be the rendering time for your
animation. You will need to find an appropriate compromise between: renderer sophistication,
algorithmic performance, animation complexity, animation aesthetics and rendering time.

## Required Submission Materials

You must upload a single zip file to the relevant submission point on Blackboard, containing:
- Your entire project folder (containing your source code, all lib files etc.)
- A Makefile that will build and run your code on the lab machines
- All OBJ geometry and material files required to run your code
- A single 480p (640×480) MP4 video file containing your ident (compressed to reduce file size)

Be sure that your project includes a working Makefile to build your renderer and ensure that your
code compiles on the MVB lab machines (this is where your code will be tested and marked !). When
you submit your code, make sure the main method is written in such a way that it will render an
initial rasterised scene. We should be able to run your code and see a render, without having to
press any keys or otherwise interact with the renderer.

Upon submission, you must also fill out
[this questionnaire](https://forms.office.com/Pages/ResponsePage.aspx?id=MH_ksn3NTkql2rGM8aQVG37h-tXTP5NGqEknVplKlalUQ1ZBNDNIMFhUVTkwQzdUQTgyR0JXUk0yWi4u)
indicating which approaches you have used to implement specific rendering features. The aim of this
is to help streamline the marking process (so that we don't spend time searching for a feature or
approach that you haven't actually implemented !)

In addition to the materials that you submit via Blackboard, you must also ensure that the
evolution of you code is clearly represented in your GitHub repository - see the following
section for more details.

## GitHub Repository

The aim of unit is to encourage evolutionary prototyping and iterative experimentation.
It's not just about the final product - we are also interested in the process by which you got there.
This assignment should be a journey of exploration, where your evolving codebase is your laboratory.
During the marking process we will access your GitHub repository in order to gain insight into
your code's evolution. It is essential that you continue to use the same repository that you have
been using during the 7 teaching weeks for your coursework assignment. Your codebase should show
a smooth transition from the building blocks developed during the teaching phase of the unit
through to the rendering engine implemented during the coursework period.

You MUST commit changes to your repository after EVERY development session (e.g. at the end of
an afternoon of coding). You should work steadily throughout the assessment period and avoid
high stress "everything at the last minute" style of development.
Only your master branch will be reviewed during the marking process - ensure that all code and
resources that you wish to be considered have been pushed to this branch.
Do not attempt anything "fancy" that will delete or hide the evolution
(e.g. squashing or rebasing) - we must be able to see the evolution of your code.

Important note: Make sure your repository is "private" so that other people can't access your code !

Not only will the use of GitHub allow us to understand the evolution of your code, but it will
also allow us to spot plagiarism. We have intelligent analysis tools that can be used to flag
unusual and anomalous commit behaviour.

Do not use someone else's computer for development during the coursework assignment (use a lab
machine or your own personal computer). There is the danger that committing/pushing from another
person's laptop will tag your commits with their GitHub username. GitHub is a mysterious creature !

## Marking criteria

Your work will be assess on the extent to which you achieve the following objectives:

- Successful implementation of different approaches to 3D rendering
(wireframe, rasterising, raytracing)

- Successful implementation of a range of different approaches to lighting and shading
(diffuse and specular lighting, shadows with ambient lighting, Phong/Gouraud shading)

- Effective animation of camera position, camera orientation and model elements

- Selection and implementation of advanced rendering features, such as:
    - "Exotic" materials (e.g. glass, mirrors, metal)
    - Surface mapping (texture maps, bump maps, environment maps)
    - Advanced lighting approaches (e.g. soft shadows, photon maps)

An indicative marking guide has been provided to illustrate the grades you might expect to
receive for a given set of features and capabilities.

## Academic Offences

Academic offences (including submission of work that is not your own, falsification of
data/evidence or the use of materials without appropriate referencing) are all taken very
seriously by the University. Suspected offences will be dealt with in accordance with the
University’s policies and procedures. If an academic offence is suspected in your work, you will
be asked to attend a plagiarism panel, where you will be given the opportunity to defend your work.
The panel are able to apply a range of penalties, depending on the severity of the offence.
These include: requirement to resubmit assignment; capping of grades to the pass mark (40%);
awarding a mark of zero for an element of assessment; awarding a mark of zero for the entire unit.

## Extenuating circumstances

If the completion of your assignment has been significantly disrupted by serious health
conditions, personal problems, periods of quarantine, or other similar issues, you may be
able to apply for consideration of extenuating circumstances (in accordance with the normal
university policy and processes). Students should apply for consideration of extenuating
circumstances as soon as possible when the problem occurs, using the following online form:
https://www.bristol.ac.uk/request-extenuating-circumstances-form

You should note however that extensions of any significant length are not possible for optional
unit assignments. If your application for extenuating circumstances is successful, you may be
required to retake the assessment of the unit at the next available opportunity (e.g. during
the summer reassessment period).
