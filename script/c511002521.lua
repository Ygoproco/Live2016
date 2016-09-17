--Relay Soul (Anime)
--By Edo9300
--Cleaned Up and Fixed by MLD
function c511002521.initial_effect(c)
	--Survive
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(511002521)
	e1:SetCondition(c511002521.condition)
	e1:SetCost(c511002521.cost)
	e1:SetTarget(c511002521.target)
	e1:SetOperation(c511002521.activate)
	c:RegisterEffect(e1)
	if not c511002521.global_check then
		c511002521.global_check=true
		Duel.RegisterFlagEffect(0,511002521,0,0,1)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CANNOT_LOSE_LP)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,0)
		ge1:SetCondition(c511002521.con)
		Duel.RegisterEffect(ge1,0)
		Duel.RegisterFlagEffect(1,511002521,0,0,1)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(c511002521.op)
		Duel.RegisterEffect(ge3,0)
	end
end
function c511002521.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=0
end
function c511002521.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,511002521)>0
end
function c511002521.op(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetLP(0)<=0 and ph~=PHASE_DAMAGE then
		Duel.RaiseEvent(Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_ONFIELD,0,nil,511002521),511002521,e,0,0,0,0)
		Duel.ResetFlagEffect(0,511002521)
	end
	if Duel.GetLP(1)<=0 and ph~=PHASE_DAMAGE then
		Duel.RaiseEvent(Duel.GetMatchingGroup(Card.IsCode,1,LOCATION_ONFIELD,0,nil,511002521),511002521,e,0,0,0,0)
		Duel.ResetFlagEffect(1,511002521)
	end
	if Duel.GetLP(0)>0 and Duel.GetFlagEffect(0,511002521)==0 then
		Duel.RegisterFlagEffect(0,511002521,0,0,1)
	end
	if Duel.GetLP(1)>0 and Duel.GetFlagEffect(1,511002521)==0 then
		Duel.RegisterFlagEffect(1,511002521,0,0,1)
	end
end
function c511002521.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_CHAIN)
	e1:SetCode(EFFECT_CANNOT_LOSE_LP)
	Duel.RegisterEffect(e1,tp)
end
function c511002521.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002521.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511002521.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511002521.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511002521.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(511002521,0,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BE_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetOperation(c511002521.matop)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_LOSE_DECK)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetLabelObject(tc)
		e2:SetCondition(c511002521.lcon)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_LOSE_LP)
		Duel.RegisterEffect(e3,tp)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
		Duel.RegisterEffect(e4,tp)
		Duel.SpecialSummonComplete()
	end
end
function c511002521.lcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetLabelObject():IsReason(REASON_DESTROY+REASON_FUSION+REASON_SYNCHRO+REASON_XYZ)
end
function c511002521.matcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION or r==REASON_SYNCHRO or r==REASON_XYZ
end
function c511002521.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(511002521)>0 then
		local rc=c:GetReasonCard()
		rc:RegisterFlagEffect(511002521,0,0,1)
		c:ResetFlagEffect(511002521)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BE_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCondition(c511002521.matcon)
		e1:SetOperation(c511002521.matop)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_LOSE_DECK)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetLabelObject(rc)
		e2:SetCondition(c511002521.lcon)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_LOSE_LP)
		Duel.RegisterEffect(e3,tp)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
		Duel.RegisterEffect(e4,tp)
	end
end
