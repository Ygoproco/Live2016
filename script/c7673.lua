--異形神の契約書
--Dark Contract with the Grotesque Lord
--Scripted by Eerie Code
function c7673.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Synchro
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7673,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(TYPE_SYNCHRO)
	e2:SetCondition(c7673.con)
	e2:SetTarget(c7673.syntg)
	e2:SetOperation(c7673.synop)
	c:RegisterEffect(e2)
	--Fusion
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(7673,0))
	e3:SetLabel(TYPE_FUSION)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTarget(c7673.fustg)
	e3:SetOperation(c7673.fusop)
	c:RegisterEffect(e3)
	--Xyz
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(7673,2))
	e4:SetLabel(TYPE_XYZ)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetTarget(c7673.xyztg)
	e4:SetOperation(c7673.xyzop)
	c:RegisterEffect(e4)
	--Pendulum
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(7673,3))
	e5:SetLabel(TYPE_PENDULUM)
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e5:SetTarget(c7673.pentg)
	e5:SetOperation(c7673.penop)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(7673,4))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c7673.damcon)
	e6:SetTarget(c7673.damtg)
	e6:SetOperation(c7673.damop)
	c:RegisterEffect(e6)
end

function c7673.cfil(c,tp,ty)
	return c:IsFaceup() and c:IsSetCard(0x10af) and c:IsType(ty) 
		and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c7673.con(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	return eg and eg:IsExists(c7673.cfil,1,nil,tp,ty)
end

function c7673.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=eg:Filter(c7673.cfil,nil,tp,TYPE_SYNCHRO)
	Duel.SetTargetCard(sg)
end
function c7673.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetValue(aux.tgoval)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end

function c7673.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c7673.fusop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

function c7673.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c7673.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function c7673.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c7673.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

function c7673.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c7673.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,2000)
end
function c7673.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
