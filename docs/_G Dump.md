Msg(msg)
 - Prints given message to console (no newline)

DotaTime()
 - Current game time (corresponds exactly to the time shown at the top of the UI). This starts *negative* and counts up to the horn.

GameTime()
 - Shows a time which increments at the same speed as DotaTime. Does not progress when paused.
 - At approximately 30 seconds into a game value is `161`. So I *guess* this starts from zero when the picking phase starts

RealTime()
 - Shows the real time since the game started (continues ticking up during a pause)

GetBot())
 - Gets a table which represents the current bot

GetTeamMember(team, index)
 - Gets a table representing the given bot.
 - Team is one of:
  - TEAM_DIRE : number
  - TEAM_NONE : number
  - TEAM_NEUTRAL : number
  - TEAM_RADIANT : number
 - index is a value of [1, 5]. Values out of range return nil.

GetGameMode()
 - Returns an integer. Presumably one of:
  - GAMEMODE_ABILITY_DRAFT : number
  - GAMEMODE_ARDM : number
  - GAMEMODE_MO : number
  - GAMEMODE_1V1MID : number
  - GAMEMODE_AP : number
  - GAMEMODE_REVERSE_CM : number
  - GAMEMODE_SD : number
  - GAMEMODE_RD : number
  - GAMEMODE_NONE : number
  - GAMEMODE_ALL_DRAFT : number
  - GAMEMODE_CM : number
  - GAMEMODE_CD : number
  - GAMEMODE_AR : number

GetScriptDirectory()
 - Path to the currently running bot. e.g. `C:\SteamLibrary\steamapps\common\dota 2 beta\game\dota\scripts\vscripts\bots`

DebugDrawText(\_, \_, \_, \_, \_, \_)
 - Some Debugging pulled out the required types: `DebugDrawText(float, float, cstring, integer, integer, integer)`
 - It seems reasonable to guess this is `x, y, message, r, g, b` however this does not print text at the expected location. Maybe there's a command to toggle visibility?

DebugDrawLine(start, end, r, g, b)
 - `start` is a `Vector(x, y, z)`
 - `end` is a `Vector(x, y, z)`
 - `r, g, b` are all values [0, 255] which together specify the colour

 DebugDrawCircle(pos, radius, r, g, b)
  - Draws an opaque circle over the game world
  - `pos` is `Vector(x, y, z)`
  - `radius` is a number
  - `r, g, b` are all values [0, 255] which together specify the colour

GetRuneStatus(\_)
 - When called like `GetRuneStatus()` throws an error: `called with 0 arguments - expected 1`

GetRuneType(\_)
 - When called like `GetRuneType()` throws an error: `called with 0 arguments - expected 1`

Vector(x, y, z)
 - Constructs a vector object

GetTeam()
 - Gets the team of the current bot. One of:
  - TEAM_DIRE : number
  - TEAM_NONE : number
  - TEAM_NEUTRAL : number
  - TEAM_RADIANT : number

\_VERSION : string
 - Version of Lua (this is currently 5.1)

debug : table
  traceback : function
  setlocal : function
  getupvalue : function
  setupvalue : function
  upvalueid : function
  getlocal : function
  getregistry : function
  getinfo : function
  sethook : function
  setmetatable : function
  upvaluejoin : function
  gethook : function
  debug : function
  getmetatable : function
  setfenv : function
  getfenv : function

BOT_MODE_DEFEND_TOWER_TOP : number
BOT_MODE_SIDE_SHOP : number
IsItemPurchasedFromSideShop : function
PURCHASE_ITEM_INVALID_ITEM_NAME : number
coroutine : table
GetNeutralSpawners : function
PURCHASE_ITEM_NOT_AT_SIDE_SHOP : number
IsCMBannedHero : function
PURCHASE_ITEM_NOT_AT_HOME_SHOP : number
PURCHASE_ITEM_INSUFFICIENT_GOLD : number
BOT_MODE_ROSHAN : number
HEROPICK_STATE_CM_BAN9 : number
PURCHASE_ITEM_SUCCESS : number
DIFFICULTY_HARD : number
DAMAGE_TYPE_PURE : number
DAMAGE_TYPE_PHYSICAL : number
BOT_MODE_DESIRE_VERYHIGH : number
HEROPICK_STATE_CM_BAN2 : number
RandomFloat : function
BOT_ACTION_DESIRE_MODERATE : number
BOT_ACTION_DESIRE_LOW : number
SetCMCaptain : function
QAngle : function
require : function
table : table
GetUnitToLocationDistance : function
setmetatable : function
GetLocationAlongLane : function
setfenv : function

newproxy : function
Min : function
pairs : function
BOT_MODE_PUSH_TOWER_TOP : number
BotTeamCommander2 : table
GetRuneTimeSinceSeen : function
IsCMPickedHero : function
GetUnitPotentialValue : function
dofile : function
BOT_MODE_ATTACK : number
RemapValClamped : function
GetGameState : function
error : function
IsPlayerInHeroSelectionControl : function
RandomVector : function
IsItemPurchasedFromSecretShop : function
SelectHero : function
GAME_STATE_CUSTOM_GAME_SETUP : number
GetCMCaptain : function
GetDefendLaneDesire : function
math : table
GetFarmLaneDesire : function
\_G : table
GetPushLaneDesire : function
LANE_BOT : number
BOT_MODE_PUSH_TOWER_BOT : number
getmetatable : function
module : function
BOT_MODE_ITEM : number
BotBaseScriptScope : table
g_reloadState : table
RUNE_STATUS_MISSING : number
GetCMPhaseTimeRemaining : function
RUNE_STATUS_UNKNOWN : number
tostring : function
rawget : function
DAMAGE_TYPE_MAGICAL : number
BOT_MODE_DEFEND_ALLY : number
BOT_MODE_DESIRE_HIGH : number
HEROPICK_STATE_CM_SELECT6 : number
Max : function
GAME_STATE_INIT : number
ipairs : function
BOT_ACTION_DESIRE_NONE : number
CMBanHero : function
print : function
printstack : function
RUNE_REGENERATION : number
pcall : function
gcinfo : function
HEROPICK_STATE_CM_BAN8 : number
GetRoshanDesire : function
RandomInt : function
BOT_MODE_WARD : number
RollPercentage : function
BOT_MODE_ROAM : number
HERO_PICK_STATE_ARDM_SELECT : number
string : table
RUNE_DOUBLEDAMAGE : number
DIFFICULTY_MEDIUM : number
HEROPICK_STATE_CM_SELECT5 : number
BOT_MODE_DESIRE_ABSOLUTE : number
DIFFICULTY_UNFAIR : number
RUNE_INVALID : number
HEROPICK_STATE_SELECT_PENALTY : number
BOT_MODE_DESIRE_LOW : number
GAME_STATE_PRE_GAME : number
HEROPICK_STATE_CM_SELECT9 : number
HEROPICK_STATE_ALL_DRAFT_SELECT : number
RUNE_ILLUSION : number
DIFFICULTY_PASSIVE : number
HERO_PICK_STATE_ABILITY_DRAFT_SELECT : number
HEROPICK_STATE_BD_SELECT : number
DIFFICULTY_INVALID : number
HEROPICK_STATE_CD_PICK : number
GAME_STATE_TEAM_SHOWCASE : number
HEROPICK_STATE_CD_SELECT10 : number
RemapVal : function
HEROPICK_STATE_CM_BAN6 : number
BOT_MODE_PUSH_TOWER_MID : number
load : function
GetSelectedHeroName : function
GetHeroPickState : function
type : function
HEROPICK_STATE_CD_SELECT9 : number
HEROPICK_STATE_CD_SELECT8 : number
HEROPICK_STATE_CD_SELECT7 : number
HEROPICK_STATE_CM_BAN10 : number
HEROPICK_STATE_CD_SELECT6 : number
BOT_MODE_LANING : number
HEROPICK_STATE_CD_SELECT5 : number
HEROPICK_STATE_CD_SELECT4 : number
HEROPICK_STATE_CD_SELECT3 : number
HEROPICK_STATE_CD_SELECT2 : number
HEROPICK_STATE_CD_SELECT1 : number
HEROPICK_STATE_AP_SELECT : number
PURCHASE_ITEM_OUT_OF_STOCK : number
HEROPICK_STATE_CD_BAN6 : number
BOT_MODE_ASSEMBLE_WITH_HUMANS : number
IsInCMBanPhase : function
xpcall : function
HEROPICK_STATE_CM_SELECT7 : number
BOT_MODE_TEAM_ROAM : number
HEROPICK_STATE_CD_BAN5 : number
HEROPICK_STATE_CD_BAN4 : number
CDOTA_Bot_Script : table
GAME_STATE_LAST : number
LANE_MID : number
BOT_ACTION_DESIRE_VERYHIGH : number
HEROPICK_STATE_CD_BAN3 : number
HEROPICK_STATE_CM_BAN1 : number
BOT_MODE_DEFEND_TOWER_BOT : number
HEROPICK_STATE_CD_BAN2 : number
HEROPICK_STATE_CD_BAN1 : number
loadstring : function
BOT_MODE_EVASIVE_MANEUVERS : number
GetItemStockCount : function
HEROPICK_STATE_CD_CAPTAINPICK : number
HEROPICK_STATE_CD_INTRO : number
CDOTA_TeamCommander : table
BOT_MODE_FARM : number
HEROPICK_STATE_FH_SELECT : number
HEROPICK_STATE_MO_SELECT : number
BOT_MODE_NONE : number
package : table
HEROPICK_STATE_CM_SELECT3 : number
HEROPICK_STATE_AR_SELECT : number
loadfile : function
HEROPICK_STATE_CM_PICK : number
IsLocationPassable : function
HEROPICK_STATE_CM_SELECT10 : number
HEROPICK_STATE_CM_SELECT8 : number
BOT_MODE_DEFEND_TOWER_MID : number
BOT_MODE_SECRET_SHOP : number
RUNE_BOUNTY : number
collectgarbage : function
HEROPICK_STATE_CM_SELECT4 : number
PURCHASE_ITEM_NOT_AT_SECRET_SHOP : number
HEROPICK_STATE_CM_SELECT2 : number
BOT_MODE_ASSEMBLE : number
select : function
HEROPICK_STATE_CM_SELECT1 : number
unpack : function
getfenv : function
PURCHASE_ITEM_DISALLOWED_ITEM : number
RUNE_INVISIBILITY : number
DAMAGE_TYPE_ALL : number
HEROPICK_STATE_CM_BAN5 : number
DIFFICULTY_EASY : number
assert : function
Clamp : function
HEROPICK_STATE_CM_BAN7 : number
GetHeightLevel : function
HEROPICK_STATE_CM_BAN4 : number
tonumber : function
HEROPICK_STATE_CM_BAN3 : number
BOT_MODE_DESIRE_VERYLOW : number
BOT_ACTION_DESIRE_HIGH : number
HEROPICK_STATE_CM_INTRO : number
HEROPICK_STATE_SD_SELECT : number
BOT_MODE_DESIRE_MODERATE : number
BOT_MODE_DESIRE_NONE : number
GAME_STATE_WAIT_FOR_MAP_TO_LOAD : number
bit : table
GAME_STATE_DISCONNECT : number
GAME_STATE_WAIT_FOR_PLAYERS_TO_LOAD : number
GetRoamDesire : function
Warning : function
GAME_STATE_GAME_IN_PROGRESS : number
GetRoamTarget : function
GAME_STATE_STRATEGY_TIME : number
BOT_MODE_RETREAT : number
BOT_ACTION_DESIRE_ABSOLUTE : number
GAME_STATE_POST_GAME : number
GAME_STATE_HERO_SELECTION : number
GetUnitToUnitDistance : function
LANE_TOP : number
GetGameStateTimeRemaining : function
LANE_NONE : number
rawset : function
RUNE_ARCANE : number
HEROPICK_STATE_CM_CAPTAINPICK : number
rawequal : function
GetWorldBounds : function
IsInCMPickPhase : function
HEROPICK_STATE_NONE : number
RUNE_STATUS_AVAILABLE : number
CMPickHero : function
next : function
CDOTABaseAbility_BotScript : table
RUNE_HASTE : number
GetItemCost : function
BOT_ACTION_DESIRE_VERYLOW : number
