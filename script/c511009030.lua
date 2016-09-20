--Shadow Guardsmen
function c511009030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCondition(c511009030.condition)
	e1:SetTarget(c511009030.target)
	e1:SetOperation(c511009030.activate)
	c:RegisterEffect(e1)
end
function c511009030.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c511009030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>0 end
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c511009030.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,511009031,0,0x4011,1,1,1,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,511009031)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local de=Effect.CreateEffect(e:GetHandler())
		de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de:SetRange(LOCATION_MZONE)
		de:SetCode(EVENT_PHASE+PHASE_BATTLE)
		de:SetOperation(c511009030.desop)
		de:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(de)
	end
	Duel.SpecialSummonComplete()
end
function c511009030.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end