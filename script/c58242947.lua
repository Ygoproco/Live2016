--ジャンク・コレクター
function c58242947.initial_effect(c)
	--copy trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58242947,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e1)
	e1:SetCost(c58242947.cost)
	e1:SetTarget(c58242947.target)
	e1:SetOperation(c58242947.operation)
	c:RegisterEffect(e1)
end
function c58242947.filter(c,e,tp,chk,chain)
	local te,eg,ep,ev,re,r,rp
	if chk==0 then
		te,eg,ep,ev,re,r,rp=c:CheckActivateEffect(false,true,true)
	end
	if not te and chk==1 then
		te=c:GetActivateEffect()
	end
	if te==nil or c:GetType()~=0x4 or not c:IsAbleToRemoveAsCost() then return false end
	local target=te:GetTarget()
	if te:GetCode()==EVENT_CHAINING and chk==1 then
		if chain<=0 then return false end
		local te2,p=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te2:GetHandler()
		local g=Group.FromCards(tc)
		eg,ep,ev,re,r,rp=g,p,chain,te2,REASON_EFFECT,p
	end
	return not target or target(e,tp,eg,ep,ev,re,r,rp,0)
end
function c58242947.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chain=Duel.GetCurrentChain()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c58242947.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,chk,chain) end
	chain=chain-1
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(58242947,1))
	local g=Duel.SelectMatchingCard(tp,c58242947.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,chk,chain)
	local te,teg,tep,tev,tre,tr,trp=g:GetFirst():CheckActivateEffect(false,true,true)
	if not te then te=g:GetFirst():GetActivateEffect() end
	if te:GetCode()==EVENT_CHAINING then
		if chain<=0 then return false end
		local te2,p=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te2:GetHandler()
		local g=Group.FromCards(tc)
		teg,tep,tev,tre,tr,trp=g,p,chain,te2,REASON_EFFECT,p
	end
	c58242947[Duel.GetCurrentChain()]=te
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetTarget(c58242947.targetchk(teg,tep,tev,tre,tr,trp))
	e:SetOperation(c58242947.operationchk(teg,tep,tev,tre,tr,trp))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabelObject(e)
	e1:SetOperation(c58242947.resetop)
	Duel.RegisterEffect(e1,tp)
end
function c58242947.targetchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local te=c58242947[Duel.GetCurrentChain()]
				if chkc then
					local tg=te:GetTarget()
					return tg(e,tp,teg,tep,tev,tre,tr,trp,0,true)
				end
				if chk==0 then return true end
				if not te then return end
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				local tg=te:GetTarget()
				if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
			end
end
function c58242947.operationchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local te=c58242947[Duel.GetCurrentChain()]
				if not te then return end
				local op=te:GetOperation()
				if op then op(e,tp,teg,tep,tev,tre,tr,trp) end
			end
end
function c58242947.resetop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		te:SetTarget(c58242947.target)
		te:SetOperation(c58242947.operation)
	end
end
function c58242947.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=c58242947[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c58242947.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=c58242947[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
