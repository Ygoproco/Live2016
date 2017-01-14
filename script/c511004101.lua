--Zombie Dog
--scripted by:urielkama
function c511004101.initial_effect(c)
--atk update
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e1:SetDescription(aux.Stringid(511004101,0))
e1:SetCategory(CATEGORY_ATKCHANGE)
e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
e1:SetHintTiming(TIMING_DAMAGE_CAL)
e1:SetRange(LOCATION_MZONE)
e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL)
e1:SetCondition(c511004101.condtion)
e1:SetOperation(c511004101.atop)
c:RegisterEffect(e1)
end
function c511004101.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and (Duel.GetAttackTarget()~=nil or Duel.GetAttackTarget()==nil)
end
function c511004101.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end