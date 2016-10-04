--Ｓｐ－カウントアップ
function c100100103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100100103.con)
	e1:SetCost(c100100103.cost)
	e1:SetTarget(c100100103.target)
	e1:SetOperation(c100100103.activate)
	c:RegisterEffect(e1)
end
function c100100103.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc and tc:GetCounter(0x91)>1 and tc:GetCounter(0x91)<12 and not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function c100100103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,63,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c100100103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
end
function c100100103.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local tc=Duel.GetFieldCard(p,LOCATION_SZONE,5)
	if not tc then return end
	local ct=e:GetLabel()
	if ct<=0 or Duel.IsPlayerAffectedByEffect(p,100100090) then return end
	local td=ct*3
	if (12-tc:GetCounter(0x91))<td then
		tc:AddCounter(0x91,12-tc:GetCounter(0x91))
	else
		tc:AddCounter(0x91,td)
	end
end
