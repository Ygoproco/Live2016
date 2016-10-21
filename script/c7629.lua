--召喚獣コキュートス
--Cocytus the Eidolon Beast
--Scripted by Eerie Code
function c7629.initial_effect(c)
	c:EnableReviveLimit()
	if Card.IsFusionAttribute then
		aux.AddFusionProcCodeFun(c,7626,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WATER),1,true,true)
	else
		aux.AddFusionProcCodeFun(c,7626,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),1,true,true)
	end
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c7629.indval)
	c:RegisterEffect(e5)
end

function c7629.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
