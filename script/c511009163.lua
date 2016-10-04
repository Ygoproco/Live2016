--inland
function c511009163.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511009163.condition)
	c:RegisterEffect(e1)
	--Change to umi
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(c511009163.sertg)
	e2:SetValue(22702055)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e3:SetValue(-1)
	c:RegisterEffect(e3)
end
function c511009163.cfilter(tc)
	return tc and tc:IsFaceup()
end
function c511009163.condition(e,tp,eg,ep,ev,re,r,rp)
	return c511009163.cfilter(Duel.GetFieldCard(tp,LOCATION_SZONE,5)) or c511009163.cfilter(Duel.GetFieldCard(1-tp,LOCATION_SZONE,5))
end
function c511009163.sertg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end