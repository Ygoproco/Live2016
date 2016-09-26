--夕日の決闘場
function c100000384.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetCondition(c100000384.descon)
	e1:SetTarget(c100000384.destg)
	e1:SetOperation(c100000384.desop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c100000384.reccon)
	e2:SetTarget(c100000384.rectg)
	e2:SetOperation(c100000384.recop)
	c:RegisterEffect(e2)
	--cannot direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e3)
end
function c100000384.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1 or Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1
end
function c100000384.filter(c,tp)
	return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,0,1,c)
end
function c100000384.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	local g=Group.CreateGroup()
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g1=Duel.SelectTarget(tp,c100000384.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		g:AddCard(g1)
	end
	if Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>1 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEUP)
		local g2=Duel.SelectTarget(1-tp,c100000384.filter,1-tp,LOCATION_MZONE,0,1,1,nil,1-tp):GetFirst()
		g:AddCard(g2)
	end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	sg:Sub(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c100000384.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:IsExists(Card.IsControler,1,nil,tp) or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1 then
		sg:Merge(g1)
	end
	if tg:IsExists(Card.IsControler,1,nil,1-tp) or Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>1 then
		sg:Merge(g2)
	end
	sg:Sub(tg)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c100000384.reccon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsFaceup()
end
function c100000384.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	if not tc:IsFaceup() then
		tc=eg:GetNext():GetBattleTarget()
	end
	Duel.SetTargetPlayer(tc:GetPreviousControler())
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tc:GetPreviousControler(),300)
end
function c100000384.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
