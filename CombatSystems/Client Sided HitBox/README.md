Client-Side Hitbox Combat System

This is a combat system that uses client-sided hitboxes for responsive gameplay. There are two `HitBoxTemplateModules` and two `CoolDownModules`—one of each stored in `ReplicatedStorage` and `ServerStorage`.

If the hitbox detects nothing, nothing is sent to the server.  
If it detects a model with a `HumanoidRootPart`, the server is sent the data for validation.  
If the hit is successfully validated, the target is damaged and a UI event is triggered to show how much damage was dealt.
