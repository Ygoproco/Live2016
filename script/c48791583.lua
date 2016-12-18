--召喚獣メガラニカ
--Magallanica the Eidolon Beast
--Scripted by Eerie Code
function c48791583.initial_effect(c)
	c:EnableReviveLimit()
	if Card.IsFusionAttribute then
		aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH,c),1,true,true)
	else
		aux.AddFusionProcCodeFun(c,86120751,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),1,true,true)
	end
end
