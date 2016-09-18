--Rank Gazer
function c511001609.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001609.tg)
	e1:SetOperation(c511001609.op)
	c:RegisterEffect(e1)
end
function c511001609.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local sum=g:GetSum(Card.GetRank)*300
	if chk==0 then return sum>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,sum)
end
function c511001609.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local sum=g:GetSum(Card.GetRank)*300
	Duel.Recover(p,sum,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c511001609.spcon)
	e1:SetOperation(c511001609.spop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c511001609.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511001609.cfilter,1,nil,tp)
end
function c511001609.cfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:GetPreviousControler()==tp and c:IsControler(tp)
end
function c511001609.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001609.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c511001609.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(102380,0)) then
		Duel.Hint(HINT_CARD,0,511001609)
		local at=eg:Filter(c511001609.cfilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local stg=Group.CreateGroup()
		local atc=at:GetFirst()
		while atc do
			stg:Merge(atc:GetOverlayGroup())
			atc=at:GetNext()
		end
		if stg:GetCount()>0 then
			Duel.SendtoGrave(stg,REASON_RULE)
		end
		Duel.Overlay(sg:GetFirst(),at)
	end
end
