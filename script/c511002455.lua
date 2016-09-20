--Blue on Blue
function c511002455.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c511002455.condition)
	e1:SetTarget(c511002455.target)
	e1:SetOperation(c511002455.activate)
	c:RegisterEffect(e1)
end
function c511002455.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c511002455.filter(c,e)
	return c:IsPosition(POS_FACEUP_ATTACK) and (not e or c:IsRelateToEffect(e))
end
function c511002455.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c511002455.filter,tp,0,LOCATION_MZONE,2,nil,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,c511002455.filter,tp,0,LOCATION_MZONE,2,2,nil,nil)
end
function c511002455.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(c511002455.filter,nil,e)~=2 then return end
	local sg=tg:Clone()
	sg:KeepAlive()
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+0x9fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_CONFIRM)
		e2:SetOperation(c511002455.atkop)
		e2:SetLabelObject(sg)
		e2:SetReset(RESET_EVENT+0x9fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
function c511002455.atkop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Hint(HINT_CARD,0,511002455)
	local d=g:Select(p,1,1,e:GetHandler()):GetFirst()
	Duel.ChangeAttackTarget(d)
	d:ResetEffect(RESET_MSCHANGE,RESET_EVENT)
	g:DeleteGroup()
end
