# Your First Game in Godot - Workshop Guide
## A 2D Platformer Demo for Linuxfest Northwest

This guide walks through creating a simple 2D platformer game using the Godot Engine in approximately 90 minutes. Perfect for beginners who want to learn the fundamentals of game development with Godot.

![Godot Engine Logo](https://godotengine.org/assets/press/logo_vertical_color_light.png)

## Prerequisites

- Godot Engine 4.2+ installed ([Download here](https://godotengine.org/download))
- Basic understanding of programming concepts (variables, functions, conditionals)
- Pre-made assets (provided in the workshop assets folder)

## Project Overview

We'll create a simple 2D platformer where the player:
- Moves and jumps through a level
- Collects coins for points
- Avoids or defeats enemies
- Reaches a goal to win

## Workshop Steps

### 1. Project Setup

#### Create a New Project
1. Open Godot Engine
2. Click "New Project"
3. Name it "FirstGodotGame"
4. Choose a project location
5. Select "2D" rendering mode
6. Click "Create & Edit"

#### Explore the Interface
- **Scene Panel**: Where you build your game objects
- **FileSystem**: Access to your project files
- **Inspector**: Edit properties of selected objects
- **Viewport**: Visual editor and game preview
- **Script Editor**: Write code for your game

#### Import Assets
1. Create folders: `assets/sprites`, `assets/sounds`
2. Extract the provided workshop assets into these folders
3. Review the available sprites and sounds

### 2. Player Character

#### Create Player Scene
1. Create a new scene (Scene > New Scene)
2. Add a CharacterBody2D node (root node)
3. Rename it to "Player"
4. Add collision: Add a CollisionShape2D as a child
5. Set collision shape to a capsule matching player size
6. Add a Sprite2D node as a child
7. Assign player sprite to the Sprite2D

#### Add Player Animation
1. Add an AnimationPlayer node
2. Create "idle", "run", and "jump" animations
3. Set up frame transitions for sprite sheets

#### Program Player Movement
1. Add a script to the Player node
2. Implement basic movement code:

```gdscript
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
    # Add the gravity
    if not is_on_floor():
        velocity.y += gravity * delta

    # Handle jump
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction
    var direction = Input.get_axis("ui_left", "ui_right")
    
    # Handle movement and animation
    if direction:
        velocity.x = direction * SPEED
        $Sprite2D.flip_h = direction < 0
        $AnimationPlayer.play("run")
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        if is_on_floor():
            $AnimationPlayer.play("idle")
    
    if not is_on_floor():
        $AnimationPlayer.play("jump")

    move_and_slide()
```

3. Save the scene as `player.tscn`

### 3. Level Design

#### Create Main Scene
1. Create a new scene with a Node2D root
2. Rename it to "Level"
3. Save as `level.tscn`

#### Add Player to Level
1. Instance the Player scene in the Level scene
2. Position the player at the starting point

#### Create Platforms
1. Add a StaticBody2D for each platform
2. Add CollisionShape2D to each platform
3. Add Sprite2D to each platform
4. Position platforms to form a level

#### Add Background
1. Add a ParallaxBackground node
2. Add a ParallaxLayer child
3. Add a Sprite2D to the ParallaxLayer
4. Assign background image to sprite

### 4. Enemies & Collectibles

#### Create Coin Scene
1. Create a new scene with Area2D root
2. Rename to "Coin"
3. Add CollisionShape2D (circle)
4. Add Sprite2D with coin texture
5. Add script to coin:

```gdscript
extends Area2D

signal coin_collected

func _on_body_entered(body):
    if body.is_in_group("player"):
        emit_signal("coin_collected")
        $AnimationPlayer.play("collect")
        await $AnimationPlayer.animation_finished
        queue_free()
```

6. Save as `coin.tscn`

#### Create Enemy Scene
1. Create a new scene with CharacterBody2D root
2. Rename to "Enemy"
3. Add CollisionShape2D
4. Add Sprite2D with enemy texture
5. Add script for basic patrol behavior:

```gdscript
extends CharacterBody2D

var direction = 1
var speed = 50
var patrol_distance = 100
var start_position

func _ready():
    start_position = global_position.x
    add_to_group("enemies")

func _physics_process(delta):
    # Patrol logic
    if global_position.x > start_position + patrol_distance:
        direction = -1
        $Sprite2D.flip_h = true
    elif global_position.x < start_position - patrol_distance:
        direction = 1
        $Sprite2D.flip_h = false
    
    velocity.x = direction * speed
    
    # Apply gravity
    if not is_on_floor():
        velocity.y += 980 * delta
    
    move_and_slide()
```

6. Save as `enemy.tscn`

#### Instance Enemies and Coins
1. Add multiple instances to your level
2. Position them appropriately

#### Create Score System
1. Add a CanvasLayer to the Level scene
2. Add a Label node for the score
3. Update Level script to track score:

```gdscript
extends Node2D

var score = 0

func _ready():
    # Connect all coins' signals
    for coin in get_tree().get_nodes_in_group("coins"):
        coin.connect("coin_collected", _on_coin_collected)
    
    update_score_display()

func _on_coin_collected():
    score += 1
    update_score_display()

func update_score_display():
    $CanvasLayer/ScoreLabel.text = "Score: " + str(score)
```

### 5. Game Logic

#### Add Victory Area
1. Add an Area2D for the finish line
2. Set up collision detection
3. Connect to level complete logic

#### Implement Player Death
1. Add collision detection with enemies
2. Create respawn functionality
3. Update Player script:

```gdscript
# Add to existing Player script
func _on_hit_enemy(body):
    if body.is_in_group("enemies"):
        # If we're falling onto the enemy, defeat it
        if velocity.y > 0:
            body.queue_free()
            velocity.y = JUMP_VELOCITY / 2
        else:
            # Player got hit
            die()

func die():
    # Death animation
    $AnimationPlayer.play("die")
    await $AnimationPlayer.animation_finished
    
    # Respawn at checkpoint
    global_position = get_parent().get_node("Checkpoint").global_position
```

#### Add Game UI
1. Create Game Over screen
2. Add victory screen
3. Make both toggle with game state

### 6. Polish

#### Add Sound Effects
1. Add AudioStreamPlayer2D nodes
2. Assign sounds for jump, coin collection, enemy defeat
3. Play sounds at appropriate moments

#### Add Simple Particles
1. Create particles for coin collection
2. Add dust particles when player jumps

#### Final Touches
1. Add game restart functionality
2. Test the entire gameplay flow
3. Fix any remaining issues

## Conclusion

Congratulations! You've built a simple but complete 2D platformer game in Godot. This project demonstrates:

- Scene and node structure
- Input handling
- Physics and collision detection
- Signals for event handling
- Animation
- Basic UI
- Game logic

## Next Steps

To continue developing your game, consider adding:
- More levels
- Different enemy types
- Power-ups
- More complex mechanics (wall jumping, double jump)
- Improved graphics and animations
- A title screen and level selection

## Resources

- [Godot Documentation](https://docs.godotengine.org/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)
- [Community Q&A](https://godotengine.org/qa/)
- [Godot Asset Library](https://godotengine.org/asset-library/asset)