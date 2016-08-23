--天使の涙
function c9032529.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9032529.target)
	e1:SetOperation(c9032529.activate)
	c:RegisterEffect(e1)
end
function c9032529.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c9032529.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(9032529,0))
	local sg=g:Select(p,1,1,nil)
	if Duel.SendtoHand(sg,1-p,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c9032529.reptg)
		e1:SetOperation(c9032529.repop)
		sg:GetFirst():RegisterEffect(e1)
		sg:GetFirst():RegisterFlagEffect(9032529,0,0,1)
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
function c9032529.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:GetFlagEffect(9032529)>0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c9032529.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(9032529)
	Duel.SendtoGrave(e:GetHandler(),e:GetHandler():GetReason(),e:GetHandler():GetOwner())
end
