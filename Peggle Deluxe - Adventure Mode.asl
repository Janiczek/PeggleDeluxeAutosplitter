// Peggle Deluxe - Adventure Mode autosplitter
// -------------------------------------------
// Works with the Steam v1.01 version of Peggle Deluxe on Windows. (Tested on Windows 10.)
// Expects 55 splits (11 stages * 5 levels).
// Starts when you click the "Adventure" button for a new profile on the main screen.
// Splits when you confirm the "Level Complete" screen after clearing a level.

state("popcapgame1")
{
  // Used for starting the game. It always plays song 49 when you start a new adventure.
  int song : "popcapgame1.exe", 0xFFD9FCD8; // static, non-pointer: 0x19FCD8 - 0x400000 + 0x100000000

  // We're tracking level transitions here.
  // It's not the level number per se -- it increments even after retries, and doesn't reset between main menu transitions.
  int levelNum : "popcapgame1.exe", 0x00250A38; // static, non-pointer: 0x650A38 - 0x400000

  // "Try Again" / "Level Complete" popup
  string1 popupTitle : "popcapgame1.exe", 0x00250908, 0x4, 0x160, 0xA4; // Either "T"(ry Again!) or "L"(evel complete)
}

init
{
  vars.hasToIgnoreFirstTransition = false;
  vars.isRetry = false;
}

start
{
  if (current.song == 49 && old.song != 49) {
    print("Peggle ASL: start");
    vars.hasToIgnoreFirstTransition = true;
    return true;
  }
  return false;
}

split
{
  vars.isRetry = current.popupTitle == "T";

  if (current.levelNum != old.levelNum) {
    if (vars.hasToIgnoreFirstTransition) {
      vars.hasToIgnoreFirstTransition = false;
      print("Peggle ASL: ignored first transition (from story to level 1-1)");
      return false;
    }
    if (vars.isRetry) {
      print("Peggle ASL: ignored retry");
      return false;
    }
    print("Peggle ASL: split");
    return true;
  }
  return false;
}
