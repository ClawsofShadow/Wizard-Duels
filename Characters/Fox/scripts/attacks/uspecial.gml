set_attack_value(AT_USPECIAL, AG_CATEGORY, 2);
set_attack_value(AT_USPECIAL, AG_SPRITE, sprite_get("uspecial"));
set_attack_value(AT_USPECIAL, AG_NUM_WINDOWS, 2);
set_attack_value(AT_USPECIAL, AG_HAS_LANDING_LAG, 4);
set_attack_value(AT_USPECIAL, AG_OFF_LEDGE, 1);
set_attack_value(AT_USPECIAL, AG_AIR_SPRITE, sprite_get("uspecial"));
set_attack_value(AT_USPECIAL, AG_HURTBOX_SPRITE, sprite_get("uspecial_hurt"));
set_attack_value(AT_USPECIAL, AG_USES_CUSTOM_GRAVITY, 1);

set_window_value(AT_USPECIAL, 1, AG_WINDOW_TYPE, 1);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_LENGTH, 40);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_ANIM_FRAMES, 8);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_HSPEED_TYPE, 1);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_VSPEED_TYPE, 1);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_HSPEED, 0);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_VSPEED, 0);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_HAS_SFX, 1);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_SFX, sound_get("fox_fire1"));
set_window_value(AT_USPECIAL, 1, AG_WINDOW_HAS_CUSTOM_FRICTION, 1);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_CUSTOM_AIR_FRICTION, 0);
set_window_value(AT_USPECIAL, 1, AG_WINDOW_CUSTOM_GROUND_FRICTION, 0);

set_window_value(AT_USPECIAL, 2, AG_WINDOW_TYPE, 7);
set_window_value(AT_USPECIAL, 2, AG_WINDOW_LENGTH, 20);
set_window_value(AT_USPECIAL, 2, AG_WINDOW_ANIM_FRAMES, 4);
set_window_value(AT_USPECIAL, 2, AG_WINDOW_ANIM_FRAME_START, 9);
set_window_value(AT_USPECIAL, 2, AG_WINDOW_HSPEED_TYPE, 1);
set_window_value(AT_USPECIAL, 2, AG_WINDOW_VSPEED_TYPE, 1);
set_window_value(AT_USPECIAL, 2, AG_WINDOW_HAS_SFX, 1);
set_window_value(AT_USPECIAL, 2, AG_WINDOW_SFX, sound_get("fox_fire3"));

set_num_hitboxes(AT_USPECIAL, 7)

set_hitbox_value(AT_USPECIAL, 1, HG_PARENT_HITBOX, 0);
set_hitbox_value(AT_USPECIAL, 1, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_USPECIAL, 1, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_USPECIAL, 1, HG_WINDOW, 1);
set_hitbox_value(AT_USPECIAL, 1, HG_WINDOW_CREATION_FRAME, 1);
set_hitbox_value(AT_USPECIAL, 1, HG_LIFETIME, 3);
set_hitbox_value(AT_USPECIAL, 1, HG_HITBOX_X, 0);
set_hitbox_value(AT_USPECIAL, 1, HG_HITBOX_Y, -32);
set_hitbox_value(AT_USPECIAL, 1, HG_WIDTH, 90);
set_hitbox_value(AT_USPECIAL, 1, HG_HEIGHT, 90);
set_hitbox_value(AT_USPECIAL, 1, HG_SHAPE, 2);
set_hitbox_value(AT_USPECIAL, 1, HG_PRIORITY, 10);
set_hitbox_value(AT_USPECIAL, 1, HG_DAMAGE, 3);
set_hitbox_value(AT_USPECIAL, 1, HG_ANGLE_FLIPPER, 2);
set_hitbox_value(AT_USPECIAL, 1, HG_BASE_KNOCKBACK, 3);
set_hitbox_value(AT_USPECIAL, 1, HG_BASE_HITPAUSE, 5);
set_hitbox_value(AT_USPECIAL, 1, HG_SDI_MULTIPLIER, 0);
set_hitbox_value(AT_USPECIAL, 1, HG_KNOCKBACK_SCALING, 0);
set_hitbox_value(AT_USPECIAL, 1, HG_HITSTUN_MULTIPLIER, 2);
set_hitbox_value(AT_USPECIAL, 1, HG_VISUAL_EFFECT, 302);
set_hitbox_value(AT_USPECIAL, 1, HG_HIT_SFX, asset_get("sfx_blow_weak2"));

set_hitbox_value(AT_USPECIAL, 2, HG_PARENT_HITBOX, 1);
set_hitbox_value(AT_USPECIAL, 2, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_USPECIAL, 2, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_USPECIAL, 2, HG_WINDOW, 1);
set_hitbox_value(AT_USPECIAL, 2, HG_WINDOW_CREATION_FRAME, 8);
set_hitbox_value(AT_USPECIAL, 2, HG_LIFETIME, 3);
set_hitbox_value(AT_USPECIAL, 2, HG_HITBOX_X, 0);
set_hitbox_value(AT_USPECIAL, 2, HG_HITBOX_Y, -32);

set_hitbox_value(AT_USPECIAL, 3, HG_PARENT_HITBOX, 1);
set_hitbox_value(AT_USPECIAL, 3, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_USPECIAL, 3, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_USPECIAL, 3, HG_WINDOW, 1);
set_hitbox_value(AT_USPECIAL, 3, HG_WINDOW_CREATION_FRAME, 16);
set_hitbox_value(AT_USPECIAL, 3, HG_LIFETIME, 3);
set_hitbox_value(AT_USPECIAL, 3, HG_HITBOX_X, 0);
set_hitbox_value(AT_USPECIAL, 3, HG_HITBOX_Y, -32);

set_hitbox_value(AT_USPECIAL, 4, HG_PARENT_HITBOX, 1);
set_hitbox_value(AT_USPECIAL, 4, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_USPECIAL, 4, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_USPECIAL, 4, HG_WINDOW, 1);
set_hitbox_value(AT_USPECIAL, 4, HG_WINDOW_CREATION_FRAME, 24);
set_hitbox_value(AT_USPECIAL, 4, HG_LIFETIME, 3);
set_hitbox_value(AT_USPECIAL, 4, HG_HITBOX_X, 0);
set_hitbox_value(AT_USPECIAL, 4, HG_HITBOX_Y, -32);
set_hitbox_value(AT_USPECIAL, 4, HG_ANGLE_FLIPPER, 1);

set_hitbox_value(AT_USPECIAL, 5, HG_PARENT_HITBOX, 1);
set_hitbox_value(AT_USPECIAL, 5, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_USPECIAL, 5, HG_HITBOX_GROUP, -1);
set_hitbox_value(AT_USPECIAL, 5, HG_WINDOW, 1);
set_hitbox_value(AT_USPECIAL, 5, HG_WINDOW_CREATION_FRAME, 32);
set_hitbox_value(AT_USPECIAL, 5, HG_LIFETIME, 3);
set_hitbox_value(AT_USPECIAL, 5, HG_HITBOX_X, 0);
set_hitbox_value(AT_USPECIAL, 5, HG_HITBOX_Y, -32);
set_hitbox_value(AT_USPECIAL, 5, HG_ANGLE_FLIPPER, 1);

set_hitbox_value(AT_USPECIAL, 6, HG_PARENT_HITBOX, 0);
set_hitbox_value(AT_USPECIAL, 6, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_USPECIAL, 6, HG_HITBOX_GROUP, 1);
set_hitbox_value(AT_USPECIAL, 6, HG_WINDOW, 2);
set_hitbox_value(AT_USPECIAL, 6, HG_WINDOW_CREATION_FRAME, 1);
set_hitbox_value(AT_USPECIAL, 6, HG_LIFETIME, 12);
set_hitbox_value(AT_USPECIAL, 6, HG_HITBOX_X, 0);
set_hitbox_value(AT_USPECIAL, 6, HG_HITBOX_Y, 0);
set_hitbox_value(AT_USPECIAL, 6, HG_WIDTH, 100);
set_hitbox_value(AT_USPECIAL, 6, HG_HEIGHT, 100);
set_hitbox_value(AT_USPECIAL, 6, HG_SHAPE, 0);
set_hitbox_value(AT_USPECIAL, 6, HG_PRIORITY, 10);
set_hitbox_value(AT_USPECIAL, 6, HG_DAMAGE, 20);
set_hitbox_value(AT_USPECIAL, 6, HG_ANGLE, 361);
set_hitbox_value(AT_USPECIAL, 6, HG_ANGLE_FLIPPER, 6);
set_hitbox_value(AT_USPECIAL, 6, HG_BASE_KNOCKBACK, 6);
set_hitbox_value(AT_USPECIAL, 6, HG_BASE_HITPAUSE, 10);
set_hitbox_value(AT_USPECIAL, 6, HG_KNOCKBACK_SCALING, 1.15);
set_hitbox_value(AT_USPECIAL, 6, HG_VISUAL_EFFECT, 302);
set_hitbox_value(AT_USPECIAL, 6, HG_HIT_SFX, asset_get("sfx_blow_heavy1"));

set_hitbox_value(AT_USPECIAL, 7, HG_PARENT_HITBOX, 0);
set_hitbox_value(AT_USPECIAL, 7, HG_HITBOX_TYPE, 1);
set_hitbox_value(AT_USPECIAL, 7, HG_HITBOX_GROUP, 1);
set_hitbox_value(AT_USPECIAL, 7, HG_WINDOW, 2);
set_hitbox_value(AT_USPECIAL, 7, HG_WINDOW_CREATION_FRAME, 13);
set_hitbox_value(AT_USPECIAL, 7, HG_LIFETIME, 38);
set_hitbox_value(AT_USPECIAL, 7, HG_HITBOX_X, 0);
set_hitbox_value(AT_USPECIAL, 7, HG_HITBOX_Y, 0);
set_hitbox_value(AT_USPECIAL, 7, HG_WIDTH, 72);
set_hitbox_value(AT_USPECIAL, 7, HG_HEIGHT, 72);
set_hitbox_value(AT_USPECIAL, 7, HG_SHAPE, 0);
set_hitbox_value(AT_USPECIAL, 7, HG_PRIORITY, 10);
set_hitbox_value(AT_USPECIAL, 7, HG_DAMAGE, 5);
set_hitbox_value(AT_USPECIAL, 7, HG_ANGLE_FLIPPER, 1);
set_hitbox_value(AT_USPECIAL, 7, HG_BASE_KNOCKBACK, 6);
set_hitbox_value(AT_USPECIAL, 7, HG_BASE_HITPAUSE, 5);
set_hitbox_value(AT_USPECIAL, 7, HG_KNOCKBACK_SCALING, 0.2);
set_hitbox_value(AT_USPECIAL, 7, HG_VISUAL_EFFECT, 302);
set_hitbox_value(AT_USPECIAL, 7, HG_HIT_SFX, asset_get("sfx_blow_weak2"));