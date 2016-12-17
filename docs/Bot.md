I discovered proper docs for this [here](http://docs.moddota.com/lua_bots/)

Documentation of the object which comes from calling `GetBot()`:

GetPlayer() : integer
 - Gets a number, in my test game (entirely full of bots) returns all of [2, 3, 4, 6, 5, 9, 10, 7, 8, 11]
 - I guess this represents player index, and for some reason starts at 2 (possibly *I* am player one, but I'm a spectator)

GetUnitName() : string
 - Name of the unit this bot is playing. e.g. `npc_dota_hero_skywrath_mage`

IsHero() : boolean
IsCreep() : boolean
IsTower() : boolean
IsBuilding() : boolean
 - The same object can represent heroes, creeps etc

GetLocation() : Vector
 - Returns a vector representing the current location

GetFacing() : integer
 - Probably an angle indicating heading?

Action_MoveToLocation(Vector) : nil
 - Begins moving to the given location

Action_ClearActions
Action_MoveToLocation
"Action_MoveToUnit",
"Action_AttackUnit",
"Action_AttackMove",
"Action_UseAbility",
"Action_UseAbilityOnEntity",
"Action_UseAbilityOnLocation",
"Action_UseAbilityOnTree",
"Action_PickUpRune",
"Action_PickUpItem",
"Action_DropItem",
"Action_PurchaseItem",
"Action_SellItem",
"Action_Buyback",
"Action_LevelAbility",
"GetDifficulty",
"IsFort",
"IsIllusion",
"CanBeSeen",
"GetActiveMode",
"GetActiveModeDesire",
"GetHealth",
"GetMaxHealth",
"GetMana",
"GetMaxMana",
"IsAlive",
"GetRespawnTime",
"HasBuyback",
"GetGold",
"GetStashValue",
"GetCourierValue",
"GetGroundHeight",
"GetAbilityByName",
"GetItemInSlot",
"IsChanneling",
"IsUsingAbility",
"GetVelocity",
"GetAttackTarget",
"GetLastSeenLocation",
"GetTimeSinceLastSeen",
"IsRooted",
"IsDisarmed",
"IsAttackImmune",
"IsSilenced",
"IsMuted",
"IsStunned",
"IsHexed",
"IsInvulnerable",
"IsMagicImmune",
"IsNightmared",
"IsBlockDisabled",
"IsEvadeDisabled",
"IsUnableToMiss",
"IsSpeciallyDeniable",
"IsDominated",
"IsBlind",
"HasScepter",
"WasRecentlyDamagedByAnyHero",
"WasRecentlyDamagedByHero",
"TimeSinceDamagedByAnyHero",
"TimeSinceDamagedByHero",
"DistanceFromFountain",
"DistanceFromSideShop",
"DistanceFromSecretShop",
"SetTarget",
"GetTarget",
"SetNextItemPurchaseValue",
"GetNextItemPurchaseValue",
"GetAssignedLane",
"GetEstimatedDamageToTarget",
"GetStunDuration",
"GetSlowDuration",
"HasBlink",
"HasMinistunOnAttack",
"HasSilence",
"HasInvisibility",
"UsingItemBreaksInvisibility",
"GetNearbyHeroes",
"GetNearbyTowers",
"GetNearbyCreeps",
"FindAoELocation",
"GetExtrapolatedLocation",
"GetMovementDirectionStability",
"GetActualDamage",
