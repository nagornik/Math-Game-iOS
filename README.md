# Math-Game-iOS-App - made in SwiftUI

An iOS game written in SwiftUI, using MVVM.

## Gameplay
The game generates a question - two numbers you must add and generates four answers, only one of which is correct. You must tap a button with the correct answer in 5 seconds while the timer goes down, showing an animated color ring.

## Features:
- Full Firebase integration
- Five difficulties
- All highscore (for each difficulty) is stored locally using @AppStorage and is always synchronized with Firebase
- Login / register with email and password
- Upload your profile picture to Firebase Storage (resize and optimize image before uploading)
- Images are shown with AsyncImage and are cached on the device
- TopResultsView shows all users who have any high score of this difficulty
- All users' list is sorted and shows position of each user and your own position
- Animations, Gestures, Haptic feedback
- Dark mode support

## iPhone 13
### Start screen, Game view, Settings view
<img src="https://user-images.githubusercontent.com/33011419/188329389-41d7e1a8-3a5c-4509-b84e-b5838a220268.gif" width="245"> <img src="https://user-images.githubusercontent.com/33011419/188329696-cfcf49c1-51e3-4d5c-9a63-a246c012013d.gif" width="245"> <img src="https://user-images.githubusercontent.com/33011419/188329739-47a7aa46-9687-41ea-8e87-f28703ea7df5.png" width="245">

### Log in / Sign up view
<img src="https://user-images.githubusercontent.com/33011419/188329786-820cfdc7-c059-4606-8ce7-aff452e6b765.png" width="245"> <img src="https://user-images.githubusercontent.com/33011419/188329791-6cab8e68-1966-42cb-a88f-a5a8480ac573.png" width="245"> <img src="https://user-images.githubusercontent.com/33011419/188329790-73571d1e-4314-4d12-8bbd-5a342f4d0597.png" width="245">

### Top Results view
<img src="https://user-images.githubusercontent.com/33011419/188329898-180f14b7-af36-429e-bb26-1df1cc312372.png" width="245"> <img src="https://user-images.githubusercontent.com/33011419/188329899-6b645ac9-1e3c-4fbf-bdfa-2118b3388575.gif" width="245">

### Dark mode support
<img src="https://user-images.githubusercontent.com/33011419/188329943-03ff6ea7-a0f1-4d67-8b67-519862de9a74.png" width="245"> <img src="https://user-images.githubusercontent.com/33011419/188329944-3a94239c-da3a-458b-991c-0043fda01812.png" width="245"> <img src="https://user-images.githubusercontent.com/33011419/188329945-184d1877-39e0-4a31-9df0-8cb21c1b98ff.png" width="245">

