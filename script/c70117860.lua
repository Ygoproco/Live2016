--ＷＷ－スノウ・ベル
--Wind Witch - Snow Bell
--Scripted by Eerie Code
function c70117860.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c70117860.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c70117860.immcon)
	e3:SetOperation(c70117860.immop)
	c:RegisterEffect(e3)
end

function c70117860.filter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c70117860.filter2(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_WIND)
end
function c70117860.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c70117860.filter1,tp,LOCATION_MZONE,0,2,nil) and not Duel.IsExistingMatchingCard(c70117860.filter2,tp,LOCATION_MZONE,0,1,nil)
end

function c70117860.immcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:GetReasonCard():IsAttribute(ATTRIBUTE_WIND)
end
function c70117860.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70117860,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(c70117860.tgvalue)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
function c70117860.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
