
TKL_UnitSide = "";

// CIVILIAN:
If ((_This Select 0) IsKindOf "Civilian") Then {TKL_UnitSide = "CIV";};

// EAST:
If ((_This Select 0) IsKindOf "SoldierEB") Then {TKL_UnitSide = "EAST";};

// GUERRILA:
If ((_This Select 0) IsKindOf "SoldierGB") Then {TKL_UnitSide = "GUER";};

// WEST:
If ((_This Select 0) IsKindOf "SoldierWB") Then {TKL_UnitSide = "WEST";};

// SPECIAL CASES:
//If ((TypeOf (_This Select 0)) In ["Doctor","PowGen_Big"]) Then {TKL_UnitSide = "WEST";};

TKL_UnitSide
