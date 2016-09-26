--Exodius the Ultimate Forbidden Lord
function c511000243.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Send 1 "Forbidden One" monster from your Hand or Deck to the Graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000243,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c511000243.forbtg)
	e2:SetOperation(c511000243.forbop)
	c:RegisterEffect(e2)
	--ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c511000243.atkval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Unaffected by Opponent Card Effects
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c511000243.unval)
	c:RegisterEffect(e5)
	--Win the Duel when there are 5 parts of the Forbidden in your Graveyard
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c511000243.winop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c511000243.winop)
	c:RegisterEffect(e7)
end
function c511000243.forbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c511000243.forbfilter(c)
	return (c:IsCode(8124921) or c:IsCode(44519536) or c:IsCode(70903634) or c:IsCode(7902349) or c:IsCode(33396948)) and c:IsAbleToGrave()
end
function c511000243.forbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c511000243.forbfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c511000243.atkfilter(c)
	return c:IsCode(8124921) or c:IsCode(44519536) or c:IsCode(70903634) or c:IsCode(7902349) or c:IsCode(33396948)
end
function c511000243.atkval(e,c)
	return Duel.GetMatchingGroupCount(c511000243.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
function c511000243.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c511000243.check(g)
	local a1=false
	local a2=false
	local a3=false
	local a4=false
	local a5=false
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetCode()
		if code==8124921 then a1=true
		elseif code==44519536 then a2=true
		elseif code==70903634 then a3=true
		elseif code==7902349 then a4=true
		elseif code==33396948 then a5=true
		end
		tc=g:GetNext()
	end
	return a1 and a2 and a3 and a4 and a5
end
function c511000243.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_EXODIUS = 0x14
	local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local wtp=c511000243.check(g1)
	local wntp=c511000243.check(g2)
	if wtp and not wntp	then
		Duel.Win(tp,WIN_REASON_EXODIUS)
	elseif not wtp and wntp then
		Duel.Win(1-tp,WIN_REASON_EXODIUS)
	elseif wtp and wntp then
		Duel.Win(PLAYER_NONE,WIN_REASON_EXODIUS)
	end
end
