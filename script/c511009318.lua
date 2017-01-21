--Performapal Pendulum Art and Clean
--fixed by MLD
function c511009318.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511009318.condition)
	e1:SetCost(c511009318.cost)
	e1:SetTarget(c511009318.target)
	e1:SetOperation(c511009318.activate)
	c:RegisterEffect(e1)
end
function c511009318.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c511009318.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c511009318.sumlimit)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():RegisterFlagEffect(511009318,RESET_PHASE+PHASE_END,0,1)
end
function c511009318.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se
end
function c511009318.filter(c,e,tp)
	return c:IsSetCard(0x9f) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511009318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c511009318.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(24919805,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		e1:SetCondition(c511009318.descon)
		e1:SetCost(c511009318.descost)
		e1:SetTarget(c511009318.destg)
		e1:SetOperation(c511009318.desop)
		e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511009318.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511009318.filter,tp,LOCATION_EXTRA,0,ft,ft,nil,e,tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DIRECT_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c511009318.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RULE)
end
function c511009318.cfilter(c)
	return c:IsSetCard(0x9f) and c:IsAbleToDeckAsCost() 
		and Duel.IsExistingMatchingCard(Card.IsStatus,0,LOCATION_MZONE,LOCATION_MZONE,1,c,STATUS_SPSUMMON_TURN)
end
function c511009318.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009318.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c511009318.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c511009318.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsStatus,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,STATUS_SPSUMMON_TURN) end
	local g=Duel.GetMatchingGroup(Card.IsStatus,tp,LOCATION_MZONE,LOCATION_MZONE,nil,STATUS_SPSUMMON_TURN)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511009318.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsStatus,tp,LOCATION_MZONE,LOCATION_MZONE,nil,STATUS_SPSUMMON_TURN)
	Duel.Destroy(g,REASON_EFFECT)
end
